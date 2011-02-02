require 'net/http'
require 'cgi'

class RdfController < ApplicationController
  def index
    query = "PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> \n PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n CONSTRUCT { ?s rdf:type rdfs:Class } WHERE { ?s rdf:type rdfs:Class }"
    Rails.logger.info("Executing query: #{query}")
    url = URI.parse(URI.parse(Rails::TRIPLESTORE['sparql-uri']))
    http = Net::HTTP.new(url.host, url.port)
    http.read_timeout = 3600
    results = http.post(url.path, "query=#{CGI.escape(query)}", {"Accept" => "application/rdf+xml"}).body
    render :text => results.body, :content_type => "application/rdf+xml"
  end
  def show
    uri = Rails::TRIPLESTORE['base-uri'] + params['rdf_uri']
    query = "CONSTRUCT { <#{uri}> ?p ?o . ?s ?r <#{uri}> } WHERE { { <#{uri}> ?p ?o } UNION { ?s ?r <#{uri}> } }"
    Rails.logger.info("Executing query: #{query}")
    url = URI.parse(URI.parse(Rails::TRIPLESTORE['sparql-uri']))
    http = Net::HTTP.new(url.host, url.port)
    http.read_timeout = 3600
    results = http.post(url.path, "query=#{CGI.escape(query)}", {"Accept" => "application/rdf+xml"}).body
    render :text => results.body, :content_type => "application/rdf+xml"
  end
end
