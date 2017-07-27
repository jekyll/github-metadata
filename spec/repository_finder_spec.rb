require "spec_helper"

RSpec.describe Jekyll::GitHubMetadata::RepositoryFinder do
  let(:overrides) { { "repository" => "jekyll/another-repo" } }
  let(:config) { Jekyll::Configuration.from(overrides) }
  let(:site) { Jekyll::Site.new config }
  before { Jekyll::GitHubMetadata.site = site }
  subject { described_class }

  context "with no repository set" do
    before(:each) do
      site.config.delete("repository")
      ENV["PAGES_REPO_NWO"] = nil
    end

    context "without a git nwo" do
      it "raises a NoRepositoryError" do
        allow(subject).to receive(:git_remote_url).and_return("")
        expect(lambda do
          subject.send(:nwo)
        end).to raise_error(Jekyll::GitHubMetadata::NoRepositoryError)
      end
    end

    it "retrieves the git remote" do
      allow(subject).to receive(:git_remote_url).and_call_original
      expect(subject.send(:git_remote_url)).to include("jekyll/github-metadata")
    end

    {
      :https => "https://github.com/foo/bar",
      :ssh   => "git@github.com:foo/bar.git",
    }.each do |type, url|
      context "with a #{type} git URL" do
        before(:each) do
          site.config.delete("repository")
          ENV["PAGES_REPO_NWO"] = nil
          ENV.delete("JEKYLL_ENV")
        end
        after(:each) { ENV["JEKYLL_ENV"] = "test" }

        it "parses the name with owner from the git URL" do
          allow(subject).to receive(:git_remote_url).and_return(url)
          expect(subject.send(:nwo)).to eql("foo/bar")
        end
      end
    end
  end

  context "with PAGES_REPO_NWO and site.repository set" do
    before(:each) { ENV["PAGES_REPO_NWO"] = "jekyll/some-repo" }

    it "uses the value from PAGES_REPO_NWO" do
      expect(subject.send(:nwo)).to eql("jekyll/some-repo")
    end
  end

  context "with only site.repository set" do
    before(:each) { ENV["PAGES_REPO_NWO"] = nil }

    it "uses the value from site.repository" do
      expect(subject.send(:nwo)).to eql("jekyll/another-repo")
    end
  end

  context "when determining the nwo via git" do
    before(:each) { ENV.delete("JEKYLL_ENV") }
    after(:each) { ENV["JEKYLL_ENV"] = "test" }

    it "handles periods in repo names" do
      allow(subject).to receive(:git_remote_url).and_return <<-EOS
  origin  https://github.com/afeld/hackerhours.org.git (fetch)
  origin  https://github.com/afeld/hackerhours.org.git (push)
  EOS
      expect(subject.send(:nwo_from_git_origin_remote)).to include("afeld/hackerhours.org")
    end

    context "when git doesn't exist" do
      before(:each) { @old_path = ENV.delete("PATH").to_s.split(File::PATH_SEPARATOR) }
      after(:each)  { ENV["PATH"] = @old_path.join(File::PATH_SEPARATOR) }

      it "fails with a nice error message" do
        allow(subject).to receive(:git_remote_url).and_call_original
        expect(subject.send(:git_exe_path)).to eql(nil)
        expect(subject.send(:git_remote_url)).to be_empty
      end
    end
  end
end
