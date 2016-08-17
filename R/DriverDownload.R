# @file DriverDownload.R
#
# Copyright 2016 Observational Health Data Sciences and Informatics
#
# This file is part of DatabaseConnector
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' Install JDBC driver in package
#' 
#' @details 
#' Installs the appropriate JDBC driver from the internet.
#' 
#' @param dbms  The type of DBMS driver to install. Valid values are
#'                           \itemize{
#'                             \item {"oracle" for Oracle}
#'                             \item {"postgresql" for PostgreSQL}
#'                             \item {"redshift" for Amazon Redshift}
#'                             \item {"sql server" for Microsoft SQL Server}
#'                             \item {"pdw" for Microsoft Parallel Data Warehouse (PDW)}
#'                           }
#' @export
installJdbcDriver <- function(dbms) {
  jarFolder <- system.file("java", package = "DatabaseConnector") 
  if (.Platform$OS.type == "windows") {
    method <- "auto"
  } else {
    method <- "curl"
  }
  if (dbms == "postgresql") {
    if (system.file("java", "postgresql-9.3-1101.jdbc4.jar", package = "DatabaseConnector") == "") {
      download.file(url = "https://jdbc.postgresql.org/download/postgresql-9.3-1101.jdbc4.jar", 
                    destfile = file.path(jarFolder, "postgresql-9.3-1101.jdbc4.jar"), 
                    method = method,
                    mode = "wb")
    }
  } else if (dbms == "sql server" || dbms == "pdw") {
    if (system.file("java", "sqljdbc4.jar", package = "DatabaseConnector") == "") {
      download.file(url = "http://download.microsoft.com/download/0/2/A/02AAE597-3865-456C-AE7F-613F99F850A8/sqljdbc_4.0.2206.100_enu.tar.gz",
                    destfile = "sqljdbc_4.0.2206.100_enu.tar.gz", 
                    method = method, 
                    mode = "wb")
      untar(tarfile = "sqljdbc_4.0.2206.100_enu.tar.gz",
            files = file.path("sqljdbc_4.0", "enu" ,"sqljdbc4.jar"))
      file.rename(file.path("sqljdbc_4.0", "enu" ,"sqljdbc4.jar"),
                  file.path(jarFolder, "sqljdbc4.jar"))
      unlink("sqljdbc_4.0.2206.100_enu.tar.gz")
      unlink("sqljdbc_4.0", recursive = TRUE)
    }
  } else if (dbms == "redshift") {
    if (system.file("java", "RedshiftJDBC4-1.1.17.1017.jar", package = "DatabaseConnector") == "") {
      download.file(url = "https://s3.amazonaws.com/redshift-downloads/drivers/RedshiftJDBC4-1.1.17.1017.jar", 
                    destfile = file.path(jarFolder, "RedshiftJDBC4-1.1.17.1017.jar"), 
                    method = method, 
                    mode = "wb")
    }
  } else if (dbms == "oracle") {
    # Do nothing
  }
  
}