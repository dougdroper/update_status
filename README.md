= status

{<img src="https://travis-ci.org/dougdroper/status.png?branch=master" alt="Build Status" />}[https://travis-ci.org/dougdroper/status]

Updates pull requests on github using the statuses api (http://developer.github.com/v3/repos/statuses/), with latest build from Jenkins and QA status

= Usage

<tt>gem install update_status</tt>


on your branch run

$: <tt>status</tt>

This will generate a .status.yml file in the current directory, you will need to edit this file with your credentials.

.status.yml:

---
:username: Jenkins username

:token: Githubs API token (http://developer.github.com/v3/oauth/)

:owner: eg. dougdroper

:password: Jenkins password

:repo: eg. status

:ci_url: eg. http://ci.jenkins.com

add .status.yml to .gitignore

When your branch has passed QA

$: <tt>status -q pass</tt>

You can pass a different branch

$: <tt>status -b other_feature_branch</tt>

or

$: <tt>status -b other_feature_branch -q pass</tt>

You can also pass based on the SHA

$: <tt>status -s SHA -q pass</tt>

help

$: <tt>status -h</tt>

== Contributing to status

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2012 Douglas Roper. See LICENSE.txt for
further details.

