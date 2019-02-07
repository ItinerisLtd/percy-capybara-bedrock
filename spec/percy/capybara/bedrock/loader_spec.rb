RSpec.describe Percy::Capybara::Bedrock::Loader do
  context "#skips?" do
    before do
      allow(File).to receive(:size).and_return(1024)
    end

    it "has a resource extension blacklist" do
      expect(Percy::Capybara::Bedrock::Loader::SKIP_RESOURCE_EXTENSIONS).not_to be_nil
      expect(Percy::Capybara::Bedrock::Loader::SKIP_RESOURCE_EXTENSIONS).not_to be Percy::Capybara::Loaders::FilesystemLoader::SKIP_RESOURCE_EXTENSIONS
    end

    it "skips blacklisted extension" do
      path = 'dummy/example.php'
      expect(Percy::Capybara::Bedrock::Loader::SKIP_RESOURCE_EXTENSIONS).to include('.php')

      loader = Percy::Capybara::Bedrock::Loader.new(web_root: __dir__)

      expect(loader.skip_extension?(path: path)).to be_truthy
      expect(loader.skip?(path: path)).to be_truthy
    end

    it "do not skip non-blacklisted extension" do
      path = 'dummy/example.php.js'
      expect(Percy::Capybara::Bedrock::Loader::SKIP_RESOURCE_EXTENSIONS).not_to include('.js')

      loader = Percy::Capybara::Bedrock::Loader.new(web_root: __dir__)

      expect(loader.skip_extension?(path: path)).to be_falsey
      expect(loader.skip?(path: path)).to be_falsey
    end

    it "has a resource basename blacklist" do
      expect(Percy::Capybara::Bedrock::Loader::SKIP_RESOURCE_BASENAMES).not_to be nil
    end

    it "skips blacklisted basename" do
      path = 'dummy/.gitignore'
      expect(Percy::Capybara::Bedrock::Loader::SKIP_RESOURCE_BASENAMES).to include('.gitignore')

      loader = Percy::Capybara::Bedrock::Loader.new(web_root: __dir__)

      expect(loader.skip_basename?(path: path)).to be_truthy
      expect(loader.skip?(path: path)).to be_truthy
    end

    it "do not skip non-blacklisted basename" do
      path = 'dummy/example.gitignore'
      expect(Percy::Capybara::Bedrock::Loader::SKIP_RESOURCE_BASENAMES).not_to include('example')

      loader = Percy::Capybara::Bedrock::Loader.new(web_root: __dir__)

      expect(loader.skip_basename?(path: path)).to be_falsey
      expect(loader.skip?(path: path)).to be_falsey
    end

    it "has a resource path blacklist" do
      expect(Percy::Capybara::Bedrock::Loader::SKIP_RESOURCE_PATHS).not_to be nil
    end

    it "skips blacklisted basename" do
      path = 'dummy/node_modules/example.js'
      expect(Percy::Capybara::Bedrock::Loader::SKIP_RESOURCE_PATHS).to include('/node_modules/')

      loader = Percy::Capybara::Bedrock::Loader.new(web_root: __dir__)

      expect(loader.skip_path?(path: path)).to be_truthy
      expect(loader.skip?(path: path)).to be_truthy
    end

    it "do not skip non-blacklisted basename" do
      path = 'dummy/node_modules2/example.js'
      expect(Percy::Capybara::Bedrock::Loader::SKIP_RESOURCE_PATHS).not_to include('node_modules2')

      loader = Percy::Capybara::Bedrock::Loader.new(web_root: __dir__)

      expect(loader.skip_path?(path: path)).to be_falsey
      expect(loader.skip?(path: path)).to be_falsey
    end

    it "has a list of resource path targets" do
      expect(Percy::Capybara::Bedrock::Loader::RESOURCE_PATHS).not_to be nil
    end

    it "skips large file" do
      path = '/dummy/large/file.js'
      file_size = Percy::Capybara::Bedrock::Loader::MAX_FILESIZE_BYTES + 1

      loader = Percy::Capybara::Bedrock::Loader.new(web_root: __dir__)
      expect(File).to receive(:size).with(path).and_return(file_size).twice

      expect(loader.skip_file_size?(path: path)).to be_truthy
      expect(loader.skip?(path: path)).to be_truthy
    end

    it "do not skip small file" do
      path = '/dummy/small/file.js'
      file_size = Percy::Capybara::Bedrock::Loader::MAX_FILESIZE_BYTES - 1

      loader = Percy::Capybara::Bedrock::Loader.new(web_root: __dir__)
      expect(File).to receive(:size).with(path).and_return(file_size).twice

      expect(loader.skip_file_size?(path: path)).to be_falsey
      expect(loader.skip?(path: path)).to be_falsey
    end

    it "do not skip valid path" do
      path = '/dummy/normal/file.css'

      loader = Percy::Capybara::Bedrock::Loader.new(web_root: __dir__)

      expect(loader.skip?(path: path)).to be_falsey
    end
  end

  context "#initialize" do
    it "accepts @web_root" do
      web_root = __dir__

      loader = Percy::Capybara::Bedrock::Loader.new(web_root: web_root)
      expect(loader.web_root).to be web_root
    end

    it "requires @web_root" do
      expect { Percy::Capybara::Bedrock::Loader.new }.to raise_error(ArgumentError, "@web_root is required")
      expect { Percy::Capybara::Bedrock::Loader.new(web_root: '') }.to raise_error(ArgumentError, "@web_root is required")
    end

    it "requires absolute @web_root" do
      web_root = '../bedrock'

      pathnameDouble = double("pathname")
      expect(pathnameDouble).to receive(:absolute?).and_return(false)
      expect(Pathname).to receive(:new).with(web_root).and_return(pathnameDouble)

      expect { Percy::Capybara::Bedrock::Loader.new(web_root: web_root) }.to raise_error(ArgumentError, "@web_root needs to be an absolute path. Received: #{web_root}")
    end

    it "requires existing @web_root" do
      web_root = __dir__

      expect(Dir).to receive(:exist?).with(web_root).and_return(false)

      expect { Percy::Capybara::Bedrock::Loader.new(web_root: web_root) }.to raise_error(ArgumentError, "@web_root provided was not found. Received: #{web_root}")
    end

    it "accepts @base_url" do
      web_root = __dir__
      base_url = '/my/base/url'

      loader = Percy::Capybara::Bedrock::Loader.new(web_root: web_root, base_url: base_url)
      expect(loader.base_url).to be base_url
    end

    it "defaults @base_url" do
      web_root = __dir__

      loader = Percy::Capybara::Bedrock::Loader.new(web_root: web_root)
      expect(loader.base_url).to eq('/')
    end
  end
end
