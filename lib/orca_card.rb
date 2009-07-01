require 'rubygems'
require 'mechanize'
require 'optparse'

##
# Prints out information about your {ORCA card}[http://orcacard.com].

class OrcaCard

  ##
  # Version of OrcaCard you are using

  VERSION = '1.1'

  ##
  # OrcaCard Error class

  class Error < RuntimeError
  end

  ##
  # Processes +args+ and returns an options Hash.

  def self.process_args(args)
    options = {}

    opts = OptionParser.new do |opts|
      opts.program_name = File.basename $0
      opts.banner = "Usage: #{opts.program_name} [options]\n\n"

      opts.on('-u', '--username=USERNAME',
              'ORCA card username') do |username|
        options[:Username] = username
              end

      opts.on('-p', '--password=PASSWORD',
              'ORCA card account password') do |password|
        options[:Password] = password
              end
    end

    opts.parse! args

    if options[:Username].nil? or options[:Password].nil? then
      $stderr.puts opts
      $stderr.puts
      $stderr.puts "username or password not set"
      exit 1
    end

    options
  end

  def self.run(args = ARGV)
    options = process_args args
    orca_card = new options
    orca_card.run
  end

  ##
  # Creates a new OrcaCard object from +options+

  def initialize(options)
    @username = options[:Username]
    @password = options[:Password]
  end

  ##
  # Returns links to card pages owned by the current account

  def cards
    agent = WWW::Mechanize.new
    login = agent.get "https://www.orcacard.com/ERG-Seattle/p7_002ad.do?m=52"

    cards = login.form_with :name => 'loginform' do |form|
      form.j_username = @username
      form.j_password = @password
    end.submit

    raise Error, $& if cards.title =~ /Authorization failed/

    cards.links_with(:text => /\d{8}/)
  end

  ##
  # Logs in, finds cards for this account and prints them on the screen

  def run
    cards.each do |card|
      view_card card
    end
  end

  ##
  # Prints information about the card for link +card+

  def view_card(card)
    card_id = card.text

    card = card.click

    passenger_type = nil
    vehicle_type = nil

    card.root.xpath('//p/strong[@class="important"]').each do |strong|
      text = strong.text.gsub(/[\r\n\t\302\240]+/u, ' ')
      next unless text =~ /Passenger Type: (.*?) Vehicle Type: (.*)/

      passenger_type = $1.downcase
      vehicle_type = $2.strip.downcase
    end

    balance = nil
    pending_balance = nil
    active = nil

    card.root.xpath('//table/tbody/tr/td').each do |td|
      if element = td.xpath('.//strong[text()="Amount:"]').first then
        td.text =~ /\$([\d.]+)/
        balance = $1.to_f
      elsif element = td.xpath('.//font[text()=" (Pending)"]').first then
        td.text =~ /\$([\d.]+)/
        pending_balance = $1.to_f
      elsif element = td.xpath('.//strong[text()="Status:"]').first then
        td.text =~ /Status: (.*)/
        active = $1.downcase
      end
    end

    if vehicle_type == 'none' then
      puts "Card %s for %s" % [card_id, passenger_type]
    else
      puts "Card %s for %s, vehicle %s" % [
        card_id, passenger_type, vehicle_type
      ]
    end

    balance = "E-purse %s, balance $%0.2f" % [active, balance]
    balance << " ($%0.2f pending)" % [pending_balance] if pending_balance
    puts balance
    puts

    history = card.links_with(:text => 'View Transaction History').first.click

    data = history.search '#resultTable'

    puts "History:"
    data.search('tr').each do |row|
      cells = row.search('td').map do |cell| cell.text.strip end

      next if cells.empty?

      time, desc, location, product, txn, balance, method = cells

      txn = txn.to_f.abs
      balance = balance.to_f.abs

      location = case location
                 when /KCM-BUS-(\d+)/ then
                   bus = $1.to_i
               "KC Metro"
                 when /ORCA Cardholder website/ then
               "ORCA website"
                 else
                   raise "unknown location %p" % location
                 end

      case desc
      when /Purse Use Journey, / then
        journey = $'

        journey = case journey
                  when /Route (\d+)/ then
                    route = $1.to_i
                "Route %3d" % route
                  else
                    raise "unknown journey %p" % journey
                  end

        if txn.zero? then
          puts "%s %s %s transfer" % [time, location, journey]
        else
          puts "%s %s %s fare $%0.2f (balance $%0.2f)" % [
            time, location, journey, txn, balance
          ]
        end
      when /Enable Product / then
        puts "%s Enabled %s" % [time, $']
      when /Add Purse Value/ then
        puts "%s Added purse value %0.2f to card" % [time, balance]
      when /Purse Add Remote, / then
        puts "%s Added purse value %0.2f to account, %s" % [time, txn, $']
      else
        raise "unknown description %p" % desc
      end
    end
  end

end

