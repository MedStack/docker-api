class Docker::Task
  include Docker::Base

  def self.all(opts = {}, conn = Docker.connection)
    hashes = Docker::Util.parse_json(conn.get("/tasks", opts))
    Array(hashes).map { |hash| new(conn, hash) }
  end
end
