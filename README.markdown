Gtool
=====

Interact with the Google Provisioning API from the command line.

Description
-----------

Gtool provides a command line interface for inspecting and interacting with
the Google Apps Provisioning API. You can create, view, edit and remove
pretty much any entity available.

Installation
------------

**as a gem**

Wait for someone to turn this into a gem.

**from source**

    git clone git://github.com/adrienthebo/ruby-gdata
    git clone git://github.com/adrienthebo/gtool

    export RUBYLIB="${RUBYLIB}:`pwd`/ruby-gdata/lib:`pwd`/gtool/lib"

    ./gtool/bin/gtool # magic!

Usage
-----

**Authentication**

    % gtool auth
    Tasks:
      gtool auth display         # Displays the cached credentials
      gtool auth generate        # Generate a token using the clientlogin method

    % gtool auth generate
    Username: user@example.com
    Password:
    Service (defaults to apps):
    Domain: example.com
    Authentication accepted, token valid till Sun Dec 04 22:32:29 -0800 2011

    % gtool auth display
    created: Sat Dec 03 22:32:29 -0800 2011 (valid)
    token: API_TOKEN_HERE

- - -

**User Manipulation**

    % gtool user
    Tasks:
      gtool user create USER     # Create a new user
      gtool user delete USER     # Delete a user
      gtool user get USER        # Get a user
      gtool user list            # List users

- - -

**Group Manipulation**

    % gtool group
    Tasks:
      gtool group addmember GROUP MEMBER  # Add a member to a group
      gtool group delmember GROUP MEMBER  # Remove a member from a group
      gtool group get GROUP               # Get a particular group instance
      gtool group list                    # List groups
      gtool group members GROUP           # Display members of a group


Rest of documentation to come when the interface is more stable.
