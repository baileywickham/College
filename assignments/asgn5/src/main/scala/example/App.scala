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
 // def main(args: Array[String]) {
 //   Logger.getLogger("org").setLevel(Level.OFF)
 //   Logger.getLogger("akka").setLevel(Level.OFF)
 //   val conf = new SparkConf().setAppName("example").setMaster("local[4]")
 //   val sc = new SparkContext(conf)
 //   sc.textFile("numbers")
 //     .filter(_.toInt % 3 == 0)
 //     .keyBy(_.toInt)
 //     .groupByKey()
 //     .collect()
 //     .foreach(x => print(x._1.toString + " appears " + x._2.toList.length + " times "))
 // }
  //def main(args: Array[String]) {
  //  Logger.getLogger("org").setLevel(Level.OFF)
  //  Logger.getLogger("akka").setLevel(Level.OFF)
  //  val conf = new SparkConf().setAppName("example").setMaster("local[4]")
  //  val sc = new SparkContext(conf)
  // sc.textFile("departments")
  //  .cartesian(sc.textFile("people"))
  //   .filter(x => x._1.split(",")(0) == x._2.split(",")(1).trim)
  //   .foreach(x => println(x._2.split(",")(0) + " " + x._1.split(",")(1)))
  //}
  def main(args: Array[String]): Unit = {
   val gpa: Map[Char, Int] = Map('A' -> 4, 'B' -> 3, 'C' -> 2, 'D' -> 1, 'F' -> 0)
    Logger.getLogger("org").setLevel(Level.OFF)
    Logger.getLogger("akka").setLevel(Level.OFF)
    val conf = new SparkConf().setAppName("example").setMaster("local[4]")
    val sc = new SparkContext(conf)
   sc.textFile("grades")
     // Splits string into lists
      .map(_.split(",", 3)(2).trim().split(", ")
        .map(_.split(" ")(0))).collect()
     // Counts GPA and number of classes using aggregate
      .map(x => x.aggregate((0,0))((x,y)=>(x._1 + gpa.getOrElse(y.charAt(0), 0), x._2 + 1),
        (x,y) => (x._1 + y._1, x._2 + y._2)))
     .foreach(x => println(x._1.toFloat/x._2.toFloat))
 }
}


