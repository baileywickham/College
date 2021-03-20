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

import scala.:+
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
    val conf = new SparkConf().setAppName("example").setMaster("local")
    val sc = new SparkContext(conf)
    val products = readProducts(sc)

    val stores = sc.textFile("stores")
      .map(x => (x.split(", ")(0), (x.split(", ")(1), x.split(", ")(3))))
    val sales = sc.textFile("sales")
      .map(x => (x.split(", ")(3), x.split(", ")))
      .join(stores)
      // ^ store id -> sales,
      .mapValues(x => Array(x._1(0), x._1(1).substring(0,7), x._1(2), x._1(3), x._1(4), x._2._1, x._2._2))
    val lineItems = sc.textFile("lineItems")
      .map(x => (x.split(", ")(1), x.split(", ")))
      .groupByKey()
      .mapValues(x =>  x.foldRight(0.0)((y,z) => products(y(2)) * y(3).toInt + z))
    //lineItems: saleID -> total
    //sals: saleID -> saleDATA
    sales.join(lineItems)
      // date, name, city, total
      .map(x => (x._2._1(1), (x._2._1(5), x._2._1(6), x._2._2)))
      .groupByKey()
      .sortByKey()
      .mapValues(x =>
        x.groupBy(_._1).mapValues(x => x.toList.map(x => (x._3)))
          .mapValues(_.sum)
      )
      .map(x => (x._1, x._2.toList.sorted))
      .foreach(println(_))
      //// store -> sum
      //.mapValues(x => x.sum)
      //.join(stores)
      //.sortBy(_._2._2)
      //.foreach(println(_))

  }
  def readStores(sc: SparkContext): RDD[(String, String, String, String, String, String, String)] = {
    //return Source.fromFile("./stores").getLines().toList
      sc.textFile("./stores")
      .map(x =>
        (x.split(", ")(0), x.split(", ")(1), x.split(", ")(2), x.split(", ")(3), x.split(", ")(4),x.split(", ")(5),x.split(", ")(6)))
  }
 def readSales(sc: SparkContext): RDD[(String, String, String, String, String)] = {
      sc.textFile("./sales")
      .map(x =>
        (x.split(", ")(0), x.split(", ")(1), x.split(", ")(2), x.split(", ")(3), x.split(", ")(4)))
  }

  def readProducts(sc : SparkContext): Map[String, Double] = {
    return Source.fromFile("./products").getLines().toList
    //sc.textFile("sales")
      .map(x =>
        (x.split(", ")(0),  x.split(", ")(2).toDouble)).toMap
  }
  def readLineItems(sc: SparkContext): RDD[(String, Array[String])] = {
    //return Source.fromFile("./lineItem").getLines().toList
      sc.textFile("lineItems")
      .map(x =>
        (x.split(", ")(2), x.split(", ")))
  }
}