# (The MIT License)
#
# Copyright (c) 2014-2019 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'digest'
require 'fileutils'

module Jekyll
  class PlantumlBlock < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
      @html = (markup or '').strip
    end

    def render(context)
      site = context.registers[:site]
      name = Digest::MD5.hexdigest(super)
      # TODO moving from ./uml/ to ./assets/uml/ is still not correct ; those files should go to the output directory directly
      subdir = "assets/uml"
      if !File.exist?(File.join(site.dest, "#{subdir}#{name}.svg"))
        uml = File.join(site.source, "#{subdir}/#{name}.uml")
        svg = File.join(site.source, "#{subdir}/#{name}.svg")
        if File.exist?(svg)
          puts "File #{svg} already exists (#{File.size(svg)} bytes)"
        else
          FileUtils.mkdir_p(File.dirname(uml))
          File.open(uml, 'w') { |f|
            f.write("@startuml\n")
            f.write(super)
            f.write("\n@enduml")
          }
          system("plantuml -tsvg #{uml}") or raise "PlantUML error: #{super}"
          site.static_files << Jekyll::StaticFile.new(
            site, site.source, subdir, "#{name}.svg"
          )
          puts "File #{svg} created (#{File.size(svg)} bytes)"
        end
      end
      # <object><svg> does not work well with fullscreen display ; <img src="*.svg"> does better
      #{}"<p><object data='#{site.baseurl}/uml/#{name}.svg' type='image/svg+xml' #{@html} class='plantuml'></object></p>"
      # TODO get the diagram's title / filename and put in id and/or alt
      "<p><img class='plantuml' id='#{name}' alt='PlantUML diagram' src='#{site.baseurl}/#{subdir}/#{name}.svg' /></p>"
    end
  end
end

Liquid::Template.register_tag('plantuml', Jekyll::PlantumlBlock)
