package testscala

import org.apache.spark.SparkContext._
import scala.util.Random
import org.apache.spark.storage._


import scala.io._
import org.apache.spark.{SparkConf, SparkContext}
import org.apache.spark.rdd._
import org.apache.log4j.Logger
import org.apache.log4j.Level
import scala.util.control.Exception._



import scala.io.StdIn.readLine


import scala.collection._

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
    while(true) {
      print("> ")
      val command = readLine().split("\\s+")
      if (command.length > 1 && (command(0) == "t" || command(0) == "transition") && command.length == 2) {
        transition_table = Option(sc.textFile(command(1))
          .flatMap(l => l.split("\\s+").sliding(prefix_length + suffix_length, 1).toList)
          .map(x => (x.slice(0, prefix_length).mkString(" "),x.slice(prefix_length, prefix_length + suffix_length).mkString(" ")))
          .groupByKey()
          .persist(StorageLevel.MEMORY_AND_DISK))
        println("Transition table for "+command(0)+" created.")
      }
      else if(command.length > 2 && command(0) == "g" || command(0) == "generate") {
        if(transition_table == None) {
          println("No transition table found")
        }
        else {
          var length = allCatch.opt(command(1).toInt).getOrElse(10)
          var tt = transition_table.getOrElse(None)
          var start = command.slice(2, command.length)
          var i = 0
          var prev = start
          print(prev.mkString(" "))
          prev = prev.slice(prev.length - prefix_length, prev.length)
          var next = transition_table.get.lookup(prev.mkString(" "))
          var s = ""
          while(next.length > 0 && i < length) {
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
      else if (command.length == 2 && command(0) == "prefix") {
        prefix_length = command(1).toInt
        println("Prefix length changed")
      }
      else if (command.length == 2 && command(0) == "suffix") {
        suffix_length = command(1).toInt
        println("Suffix length changed")
      }
    }

  }
  def getRandomWord(l: List[String], random: Random): String = {
    l(random.nextInt(l.length))
  }
}