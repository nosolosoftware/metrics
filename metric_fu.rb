# encoding: utf-8
#
# This file is part of the metrics repository. Copyright (C) 2013 and above Shogun <shogun@cowtech.it>.
# Licensed under the MIT license, which can be found at http://www.opensource.org/licenses/mit-license.php.
#

module RailsBestPractices
  module Core
    class Runner
      def self.base_path
        @base_path + '/..' || '.'
      end
    end
  end
end

module MetricFu
  def self.custom_directories
    rv = ENV['MF_SOURCES'] || Dir.pwd

    if rv
      rv = rv.split(':') if rv.index(':')
      rv = [rv] unless rv.is_a?(Array)
    end

    rv
  end

  def self.root_directory
    Dir.pwd
  end

  class CaneGenerator < Generator
    def emit
      @output = run!([abc_max_param, style_measure_param, no_doc_param, no_readme_param, directory_globs_params].join)
    end

    def directory_globs_params
      options[:dirs_to_cane] ? " --abc-glob \"%s\" --style-glob \"%s\"".gsub('%s', "{#{options[:dirs_to_cane].join(',')}}/**/*.rb") : ''
    end
  end

  class RailsBestPracticesGenerator < Generator
    def emit
      mf_debug '** Rails Best Practices'
      path = (MetricFu.custom_directories || ['.']).first
      analyzer = ::RailsBestPractices::Analyzer.new(path, 'silent' => true)
      analyzer.analyze
      @output = analyzer.errors
    end
  end

  class Template
    def file_url(name, line)
      return '' unless name
      filename = complete_file_path(name)

      link_prefix = MetricFu.configuration.templates_option('link_prefix')
      if link_prefix == MetricFu::Templates::Configuration::FILE_PREFIX
        path = filename
      else
        path = name.gsub(/:.*$/, '')
      end
      "#{link_prefix}/#{path}?line=#{line}"
    end
  end
end

MetricFu::Configuration.run do |config|
  config.templates_configuration do |templates_config|
    templates_config.link_prefix = 'vim:///'
  end

  config.configure_metrics.each do |metric|
    enabled_metrics =
      [:cane, :flog, :flay, :reek, :roodi, :rails_best_practices, :saikuro, :hotspots, :stats]
    metric.enabled = enabled_metrics.include?(metric.name)
  end

  config.configure_metric(:cane) do |metric|
    metric.dirs_to_cane = MetricFu.custom_directories if MetricFu.custom_directories
    metric.abc_max = 20
    metric.line_length = 160
    metric.no_doc = 'y'
    metric.no_readme = 'y'
  end

  config.configure_metric(:flog) do |metric|
    metric.dirs_to_flog = MetricFu.custom_directories if MetricFu.custom_directories
  end

  config.configure_metric(:flay) do |metric|
    metric.dirs_to_flay = MetricFu.custom_directories if MetricFu.custom_directories
  end

  config.configure_metric(:reek) do |metric|
    metric.dirs_to_reek = MetricFu.custom_directories if MetricFu.custom_directories
    metric.config_file_pattern = MetricFu.root_directory + '/metrics/reek.yml'
  end

  config.configure_metric(:roodi) do |metric|
    metric.dirs_to_roodi = MetricFu.custom_directories if MetricFu.custom_directories
    metric.roodi_config = MetricFu.root_directory + '/metrics/roodi.yml'
  end

  config.configure_metric(:saikuro) do |metric|
    metric.input_directory = MetricFu.custom_directories
    metric.warn_cyclo = 0
    metric.error_cyclo = 6
  end
end
