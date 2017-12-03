# frozen_string_literal: true

module EnvHelper
  def with_env(*args)
    env_hash = env_args_to_hash(*args)
    old_env = {}
    env_hash.each do |name, value|
      old_env[name] = ENV[name]
      ENV[name] = value
    end
    yield
  ensure
    old_env.each do |name, value|
      ENV[name] = value
    end
  end

  private

  def env_args_to_hash(*args)
    case args.length
    when 2
      env_hash = {}
      env_hash[args.first] = args.last
      return env_hash
    when 1
      return args.first if args.first.is_a? Hash
    end
    raise ArgumentError, "Expect 2 strings or a Hash of VAR => VAL"
  end
end
