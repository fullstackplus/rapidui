
def combine_css(source_file, dest_file)
  File.open(dest_file, 'w') do |dest|
    File.open(source_file) do |f|
      while line = f.gets
        file = line.match(/" (\w* [.] css) "/xms).captures
        file.each do |entry|
          #puts entry
          copy(dest, entry)
        end
      end
    end
  end
end

def copy(dest, source)
  File.open('../'+source) do |f|
    while line = f.gets
      line = replace_image_paths(line)
      #puts line
      dest.write(line)
    end
  end
end

=begin
  This method assumes that images are stored in the /img directory
under development but in an /images/graphics directory in deployment.
  Modify directory paths as appropriate for your project.
=end
def replace_image_paths(line)
  img_regex = / (\.\.\/img\/)(.*)(\.gif|\.jpg) /xms
  line.match(img_regex) do
    img_path = line.match(img_regex).captures[0]
    line.sub!(img_path, "/images/graphics/")
  end
  line
end

require './lib/manager.rb'

def remove_comments(source_file, dest_file)
  m = Manager.new
  File.open(dest_file, 'w') do |dest|
    File.open(source_file) do |source|
      while char = source.getc
        dest.write(m.process(char)) 
      end
      dest.write(m.get_first)
      dest.write(m.get_first)
    end
  end
end

combine_css('../screen.css', '../all.css')
remove_comments('../all.css', '../all_uncommented.css')
remove_comments('testfile.css', 'testfile_uncommented.css')