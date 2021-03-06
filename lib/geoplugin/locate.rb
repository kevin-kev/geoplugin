require 'faraday'
require 'json'
require 'ipaddress'
require 'uri'

API_URL = 'http://www.geoplugin.net/json.gp'
API_SSL_URL = 'https://ssl.geoplugin.net/json.gp'

module Geoplugin
  class	Locate
    attr_reader :request,
                :status,
                :city,
                :region,
                :areacode,
                :dmacode,
                :countrycode,
                :countryname,
                :continentcode,
                :latitude,
                :longitude,
                :regioncode,
                :regionname,
                :currencycode,
                :currencysymbol,
                :currencysymbol_utf,
                :currencyconverter

    def initialize(attributes)
      @request = attributes['geoplugin_request']
      @status = attributes['geoplugin_status']
      @city = attributes['geoplugin_city']
      @region = attributes['geoplugin_region']
      @areacode = attributes['geoplugin_areaCode']
      @dmacode = attributes['geoplugin_dmaCode']
      @countrycode = attributes['geoplugin_countryCode']
      @countryname = attributes['geoplugin_countryName']
      @continentcode = attributes['geoplugin_continentCode']
      @latitude = attributes['geoplugin_latitude']
      @longitude = attributes['geoplugin_longitude']
      @regioncode = attributes['geoplugin_regionCode']
      @regionname = attributes['geoplugin_regionName']
      @currencycode = attributes['geoplugin_currencyCode']
      @currencysymbol = attributes['geoplugin_currencySymbol']
      @currencysymbol_utf = attributes['geoplugin_currencySymbol_UTF8']
      @currencyconverter = attributes['geoplugin_currencyConverter']
    end

    # locate
    def self.locate(ip = nil, options)
      response = apiresponse(ip, options)
      new(response) unless response.empty?
    end
    
    private

    private_class_method 
    def self.apiresponse(ip = nil, options = {})
      return [] unless (not ip or IPAddress.valid? ip)
      url = "#{options[:ssl] ? API_SSL_URL : API_URL}?#{ip ? 'ip=' + ip : '?jsoncallback=?'}#{options[:key] ? '&k=' + options[:key] : ''}#{options[:base_currency] ? '&base_currency=' + options[:base_currency] : ''}"
      response = Faraday.get(URI.parse(URI.encode(url)))
      response.success? ? JSON.parse(response.body) : []
    end
  end
end
