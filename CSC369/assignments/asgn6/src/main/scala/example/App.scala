package example
import breeze.linalg.Axis._1
import breeze.linalg.{mapValues, min}
import org.apache.spark.SparkContext._

import scala.io._
import org.apache.spark.{SparkConf, SparkContext}
import org.apache.spark.rdd._
import org.apache.log4j.Logger
import org.apache.log4j.Level
import spire.math.Polynomial.x

import scala.collection._

object App {
  def main(args: Array[String]): Unit = {
    Logger.getLogger("org").setLevel(Level.OFF)
    Logger.getLogger("akka").setLevel(Level.OFF)
    val conf = new SparkConf().setAppName("example").setMaster("local")
    val sc = new SparkContext(conf)
    val g = sc.textFile("grades")
      .map(x => (x.split(", ")(1), x.split(", ")))
    val d = sc.textFile("diff")
      .map(x => (x.split(", ")(0), x.split(", ")(1).toInt))
    val p = sc.textFile("people")
     .map(x => (x.split(", ")(1), x.split(", ")))

    val top = sc.parallelize(d.sortBy(-_._2).take(1))
    g.join(top)
      .map(x => (x._2._1(0), x._2._1(1)))
      .join(p)
      .foreach(println(_))
  }
  def main(args: Array[String]): Unit = {
    Logger.getLogger("org").setLevel(Level.OFF)
    Logger.getLogger("akka").setLevel(Level.OFF)
    val conf = new SparkConf().setAppName("example").setMaster("local")
    val sc = new SparkContext(conf)
    val g = sc.textFile("grades")
      .map(x => (x.split(", ")(1), x.split(", ")))
    val p = sc.textFile("people")
      .map(x => (x.split(", ")(1), x.split(", ")(0)))
    val d = sc.textFile("diff")
      .map(x => (x.split(", ")(0), x.split(", ")(1).toInt))

    g.join(d)
      .map(x => (x._2._1(0), x._2._2))
      .groupByKey()
      .mapValues(x => x.sum.toDouble / x.size.toDouble)
      .rightOuterJoin(p)
      .foreach(x => println(x._2._2 + " difficulty: " + x._2._1.getOrElse(0)))
  }
  def main(args: Array[String]): Unit = {
    Logger.getLogger("org").setLevel(Level.OFF)
    Logger.getLogger("akka").setLevel(Level.OFF)
    val conf = new SparkConf().setAppName("example").setMaster("local")
    val sc = new SparkContext(conf)
    sc.textFile("diff")
      .map(x => (x.split(", ")(0), x.split(", ")(1).toInt))
      .sortBy(-_._2)
      .take(5)
      .foreach(println(_))
   }
  def main(args: Array[String]): Unit = {
   val gpa: Map[Char, Int] = Map('A' -> 4, 'B' -> 3, 'C' -> 2, 'D' -> 1, 'F' -> 0)
   Logger.getLogger("org").setLevel(Level.OFF)
    Logger.getLogger("akka").setLevel(Level.OFF)
    val conf = new SparkConf().setAppName("example").setMaster("local")
    val sc = new SparkContext(conf)
    val g = sc.textFile("grades")
      .map(x => (x.split(", ")(0), x.split(", ")))
    val p = sc.textFile("people")
      .map(x => (x.split(", ")(1), x.split(", ")(0)))

   g.groupByKey()
    .map(x => (x._1, x._2.aggregate((0,0))((x,y)=>(x._1 + gpa.getOrElse(y(2).charAt(0), 0), x._2 + 1),
             (x,y) => (x._1 + y._1, x._2 + y._2))))
     .mapValues(x => x._1.toDouble / x._2.toDouble)
     .rightOuterJoin(p)
     .foreach(x => println(x._2._2 + ": " + x._2._1.getOrElse(0)))
  }
}


