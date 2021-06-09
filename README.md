# README

Tzatziki is a small tool to collate failures from test runs for analysis.
Allows the collection of actual tests failed so we can determine problematic
tests.

# Using with Cucumber

To report errors from a cucumber test run add the following after hook

```
After do |scenario|
  begin
    if scenario.failed?
      @test_file = scenario.location.file
      @test_name = scenario.name
      @line_number = scenario.location.lines.to_s.to_i
      @failure = scenario.exception.message

      uri = URI("#{ENV.fetch('TZATZIKI_API_URL', 'http://localhost:3000')}/failures")
      res = Net::HTTP.post_form(uri, {
        repo_name: ENV.fetch('CIRCLE_PROJECT_REPONAME', ''),
        build_number: ENV.fetch('CIRCLE_BUILD_NUM', ''),
        branch: ENV.fetch('CIRCLE_BRANCH', ''),
        username: ENV.fetch('CIRCLE_USERNAME', ''),
        circle_job: ENV.fetch('CIRCLE_JOB', ''),
        test_file: @test_file,
        test_name: @test_name,
        line_number: @line_number,
        failure: @failure
      })
    end
  end
end 
```

# Using with RSPEC

Add the following after each block globally (spec_helper.rb)

```
  config.after(:each) do |example|
    begin
      if example.exception
        @test_file = example.metadata[:file_path] 
        @test_name = example.metadata[:full_description]
        @line_number = example.metadata[:line_number] 
        @failure = example.display_exception

        uri = URI("#{ENV.fetch('TZATZIKI_API_URL', 'http://localhost:3000')}/failures")
        res = Net::HTTP.post_form(uri, {
          repo_name: ENV.fetch('CIRCLE_PROJECT_REPONAME', ''),
          build_number: ENV.fetch('CIRCLE_BUILD_NUM', ''),
          branch: ENV.fetch('CIRCLE_BRANCH', ''),
          username: ENV.fetch('CIRCLE_USERNAME', ''),
          circle_job: ENV.fetch('CIRCLE_JOB', ''),
          test_file: @test_file,
          test_name: @test_name,
          line_number: @line_number,
          failure: @failure
        })
        puts res
      end
    rescue => e
      puts e
    end
  end
```

# Using VCR?

If you are using VCR you need to set it up so tests suite is allowed to
communicate with your tzatziki host:

```
  if ENV.fetch('TZATZIKI_API_URL')
    c.ignore_host ENV.fetch('TZATZIKI_API_URL').gsub('https://', '').gsub('/', '')
  end
```
