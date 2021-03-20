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
  // store:  ID, storeName, address, city, ZIP, state, phoneNumber
  // customer: ID, name, birth date, address, city, ZIP, state, phoneNumber
  // sales: ID, date, time, storeID, customerID
  // product: ID, description, price
  // lineItem: ID, salesID, productID, quantity
  def main(args: Array[String]) {
    Logger.getLogger("org").setLevel(Level.OFF)
    Logger.getLogger("akka").setLevel(Level.OFF)
    val products = readProducts
    val saleTotal = readLineItems
      // salesID, price*quant
      .map(x => (x._2, products(x._3) * x._4))
      // group by sales
      .groupBy(_._1)
      // sum sales
      .mapValues(_.map(_._2).sum)
    // salesID -> sale total
    val storeTotal = readSales
      // storeID -> sale total
      .map(x => (x._4, saleTotal(x._1)))
      .groupBy(_._1)
      .mapValues(_.map(_._2).sum)
    readStores.map(x =>
      (x._6, x._1, saleTotal(x._1)))
      .sortBy(_._1)
      .foreach(println(_))
  }
  def readStores: List[(String, String, String, String, String, String, String)] = {
    return Source.fromFile("./stores").getLines().toList
      .map(x =>
        (x.split(", ")(0), x.split(", ")(1), x.split(", ")(2), x.split(", ")(3), x.split(", ")(4),x.split(", ")(5),x.split(", ")(6)))
  }
  def readCustomers: List[Any] = {
    return Source.fromFile("./customers").getLines().toList
      .map(x =>
        (x.split(", ")(0), x.split(", ")(1), x.split(", ")(2), x.split(", ")(3), x.split(", ")(4),x.split(", ")(5),x.split(", ")(6), x.split(", ")(7)))
  }
  def readSales: List[(String, String, String, String, String)] = {
    return Source.fromFile("./sales").getLines().toList
      .map(x =>
        (x.split(", ")(0), x.split(", ")(1), x.split(", ")(2), x.split(", ")(3), x.split(", ")(4)))
  }

  def readProducts: Map[String, Double] = {
    return Source.fromFile("./products").getLines().toList
      .map(x =>
        x.split(", ")(0) -> x.split(", ")(2).toDouble).toMap
  }
  def readLineItems: List[(String, String, String, Int)] = {
    return Source.fromFile("./lineItem").getLines().toList
      .map(x =>
        (x.split(", ")(0), x.split(", ")(1), x.split(", ")(2), x.split(", ")(3).toInt))
  }
}