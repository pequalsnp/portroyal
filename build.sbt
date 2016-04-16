name := """distributedmedia"""

version := "1.0-SNAPSHOT"

lazy val root = (project in file(".")).enablePlugins(PlayScala)

scalaVersion := "2.11.8"

resolvers := ("Atlassian Releases" at "https://maven.atlassian.com/public/") +: resolvers.value
resolvers += Resolver.jcenterRepo

libraryDependencies ++= Seq(
  "com.iheart" %% "ficus" % "1.2.0",
  "com.mohiva" %% "play-silhouette" % "4.0.0-BETA4",
  "com.mohiva" %% "play-silhouette-password-bcrypt" % "4.0.0-BETA4",
  "net.codingwell" %% "scala-guice" % "4.0.1",
  jdbc,
  cache,
  ws,
  "com.mohiva" %% "play-silhouette-testkit" % "4.0.0-BETA4" % "test",
  "org.scalatestplus.play" %% "scalatestplus-play" % "1.5.0-RC1" % Test
)

resolvers += "scalaz-bintray" at "http://dl.bintray.com/scalaz/releases"
