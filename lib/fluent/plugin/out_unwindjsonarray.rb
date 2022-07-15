#
# Copyright 2022- TODO: Write your name
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "fluent/plugin/output"

module Fluent
  module Plugin
    class UnwindjsonarrayOutput < Fluent::Plugin::Output
      Fluent::Plugin.register_output("unwindjsonarray", self)

      config_param :output_tag, :string, default: nil
      config_param :unwind_key, :string, default: nil

    REQUIRED_PARAMS = %w(output_tag unwind_key)

    def configure(conf)
      super
      REQUIRED_PARAMS.each do |param|
        unless config.has_key?(param)
          raise Fluent::ConfigError, "#{param} field is required"
        end
      end
    end

    def emit(tag, es, chain)
      es.each do |time, record|
        chain.next
        if record[unwind_key] && record[unwind_key].is_a?(Array)
          record[unwind_key].each do |value|
            new_record = record.dup
            new_record[unwind_key] = value
            router.emit(output_tag, time, new_record)
          end
        else
          router.emit(output_tag, time, record)
        end
      end
    end
    end
  end
end

