# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.

# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.
worker_processes 1

# Help ensure your application will always spawn in the symlinked
# "current" directory that Capistrano sets up.
home_dir = ENV['HOME_DIR'] || "/home/app/tao"
unicorn_sock_file = ENV['UNICORN_SOCK_FILE'] || "/tmp/unicorn.sock"

working_directory home_dir # available in 0.94.0+

listen unicorn_sock_file

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

# feel free to point this anywhere accessible on the filesystem
pid_file = ENV['UNICORN_PID_FILE'] || "/tmp/unicorn.pid"
pid pid_file

# By default, the Unicorn logger will write to stderr.
# Additionally, ome applications/frameworks log to stderr or stdout,
# so prevent them from going to /dev/null when daemonized here:
stderr_path "#{home_dir}/log/unicorn.err.log"
stdout_path "#{home_dir}/log/unicorn.out.log"

# combine REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  # Throttle the master from forking too quickly by sleeping.  Due
  # to the implementation of standard Unix signal handlers, this
  # helps (but does not completely) prevent identical, repeated signals
  # from being lost when the receiving process is busy.
  # sleep 1

  # Send a QUIT to the old master so it doesn't hang around.
  # cribbed and tweaked from GitHub's config: https://github.com/blog/517-unicorn
  old_pid = "#{pid_file}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

# after_fork do |server, worker|
#   # per-process listener ports for debugging/admin/migrations
#   # addr = "127.0.0.1:#{9293 + worker.nr}"
#   # server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)

#   # the following is *required* for Rails + "preload_app true",
#   defined?(ActiveRecord::Base) and
#     ActiveRecord::Base.establish_connection

#   # http://petelacey.tumblr.com/post/3073967460/on-forking-application-servers-and-memcached-in-rails
#   Rails.cache.reconnect

#   # if preload_app is true, then you may also want to check and
#   # restart any other shared sockets/descriptors such as Memcached,
#   # and Redis.  TokyoCabinet file handles are safe to reuse
#   # between any number of forked children (assuming your kernel
#   # correctly implements pread()/pwrite() system calls)
# end
