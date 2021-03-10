package example
import breeze.linalg.Axis._1
import breeze.linalg.{mapValues, min}
import org.apache.spark.SparkContext._

import scala.io._
import org.apache.log4j.Logger
import org.apache.log4j.Level
import org.apache.spark.sql.SparkSession
import org.apache.spark
import org.apache.spark.sql.functions.from_json
import spire.math.Polynomial.x

import scala.collection._

object App {
  def main(args: Array[String]): Unit = {
    Logger.getLogger("org").setLevel(Level.OFF)
    Logger.getLogger("akka").setLevel(Level.OFF)
    val lines = Source.fromFile("./sales").getLines().toList
        lines.map(line => (line.split(",")(0).trim, line.split(",")(2), line.split(",")(3).trim.toInt, line.split(",")(4).trim.toInt))
          .groupBy(_._1) //x => (x._1, x._2))
          .mapValues(v => v.foldRight(0)((x, y) => x._4 + y))
          //.map(x => (x._1, x._2.sorted) ) // default sort method sorts element     wise, which is what we want
          //.toList.sortBy(_._1)
          .foreach(println(_))
  }
}


