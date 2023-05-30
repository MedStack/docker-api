# This class represents a Docker Swarm instance. It's important to note that nothing
# is cached so that the information is always up to date.
class Docker::Swarm
  include Docker::Base

  def self.inspect(conn = Docker.connection)
    new(conn, Docker::Util.parse_json(conn.get('/swarm')))
  end

  def self.init(opts = {}, conn = Docker.connection)
    conn.post('/swarm/init', {}, :body => opts.to_json)
    inspect(conn)
  end

  def self.join(opts = {}, conn = Docker.connection)
    !!conn.post('/swarm/join', {}, :body => opts.to_json)
  end

  def self.leave(force = false, conn = Docker.connection)
    query = {
      "force" => force
    }

    !!conn.post('/swarm/leave', query)
  end

  def self.update(opts = {}, conn = Docker.connection)
    !!conn.post('/swarm/join', {}, :body => opts.to_json)
  end

  private_class_method :new
end
