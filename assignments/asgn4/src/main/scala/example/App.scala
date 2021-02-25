package example
import breeze.linalg.Axis._1
import breeze.linalg.mapValues
import org.apache.spark.SparkContext._

import scala.io._
import org.apache.spark.{SparkConf, SparkContext}
import org.apache.spark.rdd._
import org.apache.log4j.Logger
import org.apache.log4j.Level
import spire.math.Polynomial.x

import scala.collection._

object App {
//  def main(args: Array[String]) {
//    Logger.getLogger("org").setLevel(Level.OFF)
//    Logger.getLogger("akka").setLevel(Level.OFF)
//    val lines = Source.fromFile("./input.txt").getLines().toList
//    println(lines.count(x => x.toInt % 3 == 0))
//  }
//
//  def main(args: Array[String]) {
//    Logger.getLogger("org").setLevel(Level.OFF)
//    Logger.getLogger("akka").setLevel(Level.OFF)
//    val lines = Source.fromFile("./temp").getLines().toList
//    lines.map(line => (line.split(" ")(0),
//      (line.split(" ")(1).toInt)))
//        .groupBy(_._1)
//        .map(x => x._2.max) // this works because of how groupBy(_._1) works, inculding the key
//        .foreach(println(_))
//  }
  def main(args: Array[String]) {
    Logger.getLogger("org").setLevel(Level.OFF)
    Logger.getLogger("akka").setLevel(Level.OFF)
    val lines = Source.fromFile("./classes").getLines().toList
    lines.map(line => (
      (line.split(",")(0).trim, line.split(",")(1).trim().toInt),
      (line.split(",")(2).trim, line.split(",")(3).trim)))
        .groupBy(_._1)//x => (x._1, x._2))
        .mapValues(v => v.map(x=> x._2))
        .map(x => (x._1, x._2.sorted) ) // default sort method sorts element wise, which is what we want
        .toList.sortBy(_._1)
        .foreach(println(_))
  }
}


