require_relative './lib/db_connection.rb'
require 'pg'

desc 'sets up the test database with 3 links'
  task :test_database_setup do
    p "Setting up the test database table..."
    Db_Connection.setup('bookmark_manager_test', 'julesnuggy')
    Db_Connection.query("DELETE FROM links")
    Db_Connection.query("ALTER SEQUENCE links_id_seq RESTART WITH 1")
    Db_Connection.query("INSERT INTO links (url) VALUES ('www.google.com');")
    Db_Connection.query("INSERT INTO links (url) VALUES ('www.facebook.com');")
    Db_Connection.query("INSERT INTO links (url) VALUES ('www.makersacademy.com');")
  end

desc 'sets up development and test databases and tables from scratch'
  task :setup do
    p "Creating databases..."
    connection = PG.connect
    connection.exec("CREATE DATABASE bookmarks_manager_test;")
    connection.exec("CREATE DATABASE bookmarks_manager;")

    Db_Connection.setup('bookmark_manager_test', 'julesnuggy')
    Db_Connection.query("CREATE TABLE links (id SERIAL PRIMARY KEY, url VARCHAR(60));")

    Db_Connection.setup('bookmark_manager', 'julesnuggy')
    Db_Connection.query("CREATE TABLE links (id SERIAL PRIMARY KEY, url VARCHAR(60));")
  end
