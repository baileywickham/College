package testscala

import org.apache.log4j.{Level, Logger}
import org.apache.spark.rdd.RDD
import org.apache.spark.storage.StorageLevel
import org.apache.spark.{SparkConf, SparkContext}

import scala.collection.Iterable
import scala.io.StdIn.readLine
import scala.util.Random
import scala.util.control.Exception.allCatch

object App {

  def main(args: Array[String]): Unit = {
    Logger.getLogger("org").setLevel(Level.OFF)
    Logger.getLogger("akka").setLevel(Level.OFF)
    val conf = new SparkConf().setAppName("example").setMaster("local")
    val sc = new SparkContext(conf)

    var prefix_length = 2
    var suffix_length = 3
    val random = new Random
    var transition_table = None: Option[RDD[(String, Iterable[String])]]
    println("t <fileName> - create Transition table on existing fileName\n" +
            "g <int> - generate  followed by number of iterations\n" +
            "prefix <int> - change prefix length. Current value = " + prefix_length + "\n" +
            "suffix <int> - change suffix length. Current Value = " + suffix_length + "\n")
    while (true) {
      print("> ")
      val command = readLine().split("\\s+")
      if (command.length > 1 && (command(0) == "t" || command(0) == "transition") && command.length == 2 || command.length == 3) {
        var f : String => Array[String] = {x => split_whitespace(x)}
        if (command.length == 3 && command(2) == "xml") {
          f = (x => split_brackets(x))
        }
        transition_table = Option(sc.textFile(command(1))
          .flatMap(l => f(l).sliding(prefix_length + suffix_length, 1).toList)
          .map(x => (x.slice(0, prefix_length).mkString(" "), x.slice(prefix_length, prefix_length + suffix_length).mkString(" ")))
          .groupByKey()
          .persist(StorageLevel.MEMORY_AND_DISK))
        println("Transition table for " + command(0) + " created.")
      }
      else if (command.length > 2 && command(0) == "g" || command(0) == "generate") {
        if (transition_table.isEmpty) {
          println("No transition table found")
        }
        else {
          var length = allCatch.opt(command(1).toInt).getOrElse(10)
          var start = command.slice(2, command.length)
          var i = 0
          var prev = start
          print(prev.mkString(" "))
          prev = prev.slice(prev.length - prefix_length, prev.length)
          var next = transition_table.get.lookup(prev.mkString(" "))
          var s = ""
          while (next.length > 0 && i < length) {
            i += 1
            s = getRandomWord(next(0).toList, random)
            print(" " + s)
            prev = prev ++ s.split("\\s+")
            prev = prev.slice(prev.length - prefix_length, prev.length)
            next = transition_table.get.lookup(prev.mkString(" "))
          }
          println()
        }
      }
      else if (command.length == 2 && command(0) == "g") {
        if (transition_table.isEmpty) {
          println("No transition table found")
        } else {
          val length = allCatch.opt(command(1).toInt).getOrElse(10)
          val start = Array(getRandomWord(transition_table.get
            .map(x => x._1)
            .collect().toList, random))
          var prev = start
          print(prev.mkString(" "))
          prev = prev.slice(prev.length - prefix_length, prev.length)
          var next = transition_table.get.lookup(prev.mkString(" "))
          var s = ""
          var i = 0
          while (next.nonEmpty && i < length) {
            i += 1
            s = getRandomWord(next.head.toList, random)
            print(" " + s)
            prev = prev ++ s.split("\\s+")
            prev = prev.slice(prev.length - prefix_length, prev.length)
            next = transition_table.get.lookup(prev.mkString(" "))
          }
          println()
        }

      }
      else if (command.length == 2 && command(0) == "prefix") {
        prefix_length = command(1).toInt
        println("Prefix length changed to " + prefix_length)
      }
      else if (command.length == 2 && command(0) == "suffix") {
        suffix_length = command(1).toInt
        println("Suffix length changed to" + suffix_length)
      }
      else {
        help
      }
    }

  }

  def getRandomWord(l: List[String], random: Random): String = {
    l(random.nextInt(l.length))
  }
  def split_whitespace(s: String): Array[String] = {
      s.split("\\s+")
  }
  def split_brackets(s: String): Array[String] = {
    s.split("(<|>)")
  }
  def help = {
    println("suffix <int>\n" +
      "prefix <int>\n" +
      "transition <filename>\n" +
      "generate <int> <prefix>\n")
  }
}
