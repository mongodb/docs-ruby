# Command monitoring

# start-available-subscriber
Mongo::Monitoring::Global.subscribe(Mongo::Monitoring::COMMAND, subscriber)
client = Mongo::Client.new(['127.0.0.1:27017'])

client.subscribe( Mongo::Monitoring::COMMAND, subscriber )
# end-available-subscriber

# start-command-logging
class CommandLogSubscriber
    include Mongo::Loggable
  
    def started(event)
      # The default inspection of a command which is a BSON document gets
      # truncated in the middle. To get the full rendering of the command, the
      # ``to_json`` method can be called on the document.
      log_debug("#{prefix(event)} | STARTED | #{format_command(event.command.to_json)}")
    end
  
    def succeeded(event)
      log_debug("#{prefix(event)} | SUCCEEDED | #{event.duration}s")
    end
  
    def failed(event)
      log_debug("#{prefix(event)} | FAILED | #{event.message} | #{event.duration}s")
    end
  
    private
  
    def logger
      Mongo::Logger.logger
    end
  
    def format_command(args)
      begin
        args.inspect
      rescue Exception
        '<Unable to inspect arguments>'
      end
    end
  
    def format_message(message)
      format("COMMAND | %s".freeze, message)
    end
  
    def prefix(event)
      "#{event.address.to_s} | #{event.database_name}.#{event.command_name}"
    end
  end
# end-command-logging

# start-command-subscriber
subscriber = CommandLogSubscriber.new

Mongo::Monitoring::Global.subscribe(Mongo::Monitoring::COMMAND, subscriber)

client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'test' )
client.subscribe( Mongo::Monitoring::COMMAND, subscriber )
# end-command-subscriber

# start-sdam
class SDAMLogSubscriber
    include Mongo::Loggable
  
    def succeeded(event)
      log_debug(format_event(event))
    end
  
    private
  
    def logger
      Mongo::Logger.logger
    end
  
    def format_message(message)
      format("SDAM | %s".freeze, message)
    end
  end
  
  class TopologyOpeningLogSubscriber < SDAMLogSubscriber
    private
  
    def format_event(event)
      "Topology type '#{event.topology.display_name}' initializing."
    end
  end
  
  class ServerOpeningLogSubscriber < SDAMLogSubscriber
    private
  
    def format_event(event)
      "Server #{event.address} initializing."
    end
  end
  
  class ServerDescriptionChangedLogSubscriber < SDAMLogSubscriber
    private
  
    def format_event(event)
      "Server description for #{event.address} changed from " +
      "'#{event.previous_description.server_type}' to '#{event.new_description.server_type}'."
    end
  end
  
  class TopologyChangedLogSubscriber < SDAMLogSubscriber
    private
  
    def format_event(event)
      if event.previous_topology != event.new_topology
        "Topology type '#{event.previous_topology.display_name}' changed to " +
        "type '#{event.new_topology.display_name}'."
      else
        "There was a change in the members of the '#{event.new_topology.display_name}' " +
        "topology."
      end
    end
  end
  
  class ServerClosedLogSubscriber < SDAMLogSubscriber
    private
  
    def format_event(event)
      "Server #{event.address} connection closed."
    end
  end
  
  class TopologyClosedLogSubscriber < SDAMLogSubscriber
    private
  
    def format_event(event)
      "Topology type '#{event.topology.display_name}' closed."
    end
  end
#end-sdam

# start-sdam-subscriber-global
topology_opening_subscriber = TopologyOpeningLogSubscriber.new
server_opening_subscriber = ServerOpeningLogSubscriber.new
server_description_changed_subscriber = ServerDescriptionChangedLogSubscriber.new
topology_changed_subscriber = TopologyChangedLogSubscriber.new
server_closed_subscriber = ServerClosedLogSubscriber.new
topology_closed_subscriber = TopologyClosedLogSubscriber.new

Mongo::Monitoring::Global.subscribe(Mongo::Monitoring::TOPOLOGY_OPENING,
  topology_opening_subscriber)
Mongo::Monitoring::Global.subscribe(Mongo::Monitoring::SERVER_OPENING,
  server_opening_subscriber)
Mongo::Monitoring::Global.subscribe(Mongo::Monitoring::SERVER_DESCRIPTION_CHANGED,
  server_description_changed_subscriber)
Mongo::Monitoring::Global.subscribe(Mongo::Monitoring::TOPOLOGY_CHANGED,
  topology_changed_subscriber)
Mongo::Monitoring::Global.subscribe(Mongo::Monitoring::SERVER_CLOSED,
  server_closed_subscriber)
Mongo::Monitoring::Global.subscribe(Mongo::Monitoring::TOPOLOGY_CLOSED,
  topology_closed_subscriber)
# end-sdam-subscriber-global

# start-sdam-subscriber-client
topology_opening_subscriber = TopologyOpeningLogSubscriber.new
server_opening_subscriber = ServerOpeningLogSubscriber.new
server_description_changed_subscriber = ServerDescriptionChangedLogSubscriber.new
topology_changed_subscriber = TopologyChangedLogSubscriber.new
server_closed_subscriber = ServerClosedLogSubscriber.new
topology_closed_subscriber = TopologyClosedLogSubscriber.new

sdam_proc = Proc.new do |client|
  client.subscribe(Mongo::Monitoring::TOPOLOGY_OPENING,
    topology_opening_subscriber)
  client.subscribe(Mongo::Monitoring::SERVER_OPENING,
    server_opening_subscriber)
  client.subscribe(Mongo::Monitoring::SERVER_DESCRIPTION_CHANGED,
    server_description_changed_subscriber)
  client.subscribe(Mongo::Monitoring::TOPOLOGY_CHANGED,
    topology_changed_subscriber)
  client.subscribe(Mongo::Monitoring::SERVER_CLOSED,
    server_closed_subscriber)
  client.subscribe(Mongo::Monitoring::TOPOLOGY_CLOSED,
    topology_closed_subscriber)
end

client = Mongo::Client.new(['127.0.0.1:27017'], database: 'test',
  sdam_proc: sdam_proc)
# end-sdam-subscriber-client

# start-heartbeat
class HeartbeatLogSubscriber
    include Mongo::Loggable
  
    def started(event)
      log_debug("#{event.address} | STARTED")
    end
  
    def succeeded(event)
      log_debug("#{event.address} | SUCCEEDED | #{event.duration}s")
    end
  
    def failed(event)
      log_debug("#{event.address} | FAILED | #{event.error.class}: #{event.error.message} | #{event.duration}s")
    end
  
    private
  
    def logger
      Mongo::Logger.logger
    end
  
    def format_message(message)
      format("HEARTBEAT | %s".freeze, message)
    end
  end
# end-heartbeat

# start-heartbeat-subscribe
subscriber = HeartbeatLogSubscriber.new

Mongo::Monitoring::Global.subscribe(Mongo::Monitoring::SERVER_HEARTBEAT, subscriber)

client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'test' )
client.subscribe( Mongo::Monitoring::SERVER_HEARTBEAT, subscriber )
# end-heartbeat-subscribe

# Connection Pool
# start-pool-subscriber
Mongo::Monitoring::Global.subscribe(
  Mongo::Monitoring::CONNECTION_POOL,
  Mongo::Monitoring::CmapLogSubscriber.new)

client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'test' )
subscriber = Mongo::Monitoring::CmapLogSubscriber.new
client.subscribe( Mongo::Monitoring::CONNECTION_POOL, subscriber )
# end-pool-subscriber
