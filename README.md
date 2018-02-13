# Codeforces Solution Scrapper

### A tool that lets you download your accepted solutions locally, and initializes a git repository with it.

#### How to use it?
Clone the repo and open a new terminal / command prompt in the repos' path. Make sure you have ruby installed.
Currently executable file is not available so you have to run the following:


* <i>gem install nokogiri</i>

* <i>gem install mechanize</i>

And then to download your solutions from Codeforces run the following:

* <i>ruby run.rb \<handle> \<password></i>

Make sure you put your handle and password between quotations. <i>(e.g ruby run.rb "your_handle_here" "your_password_here")</i>. The program will download all your accepted solutions in the folder <i>"codeforces-solutions"</i>
