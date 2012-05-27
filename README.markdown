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

    gem install gtool
    % gtool # magic!

**from source**

    git clone git://github.com/adrienthebo/ruby-gprov
    git clone git://github.com/adrienthebo/gtool

    export RUBYLIB="${RUBYLIB}:`pwd`/ruby-gprov/lib:`pwd`/gtool/lib"
    export PATH="${PATH}:`pwd`/gtool/bin"

    % gtool # more magic!

Usage
-----

**General Usage**

    % gtool
    Tasks:
      gtool auth [COMMAND]       # GProv authentication operations
      gtool customerid           # Display Customer ID for the domain
      gtool group [COMMAND]      # GProv group provisioning
      gtool help [TASK]          # Describe available tasks or one specific task
      gtool orgmember [COMMAND]  # GProv organizational member provisioning
      gtool orgunit [COMMAND]    # GProv organizational unit provisioning
      gtool user [COMMAND]       # GProv user provisioning

- - -

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

**View Customer ID information**

    % gtool customerid
    Customer id:                    CUSTOMER_ID_HERE
    Name:                           example.com
    Description:
    Customer org unit name:         example.com
    Customer org unit description:  example.com

- - -

**Groups**

    % gtool group
    Tasks:
      gtool group addmember GROUP MEMBER  # Add a member to a group
      gtool group delmember GROUP MEMBER  # Remove a member from a group
      gtool group get GROUP               # Get a particular group instance
      gtool group list                    # List groups
      gtool group members GROUP           # Display members of a group

- - -

**Users**

    % gtool user
    Tasks:
      gtool user create USER     # Create a new user
      gtool user delete USER     # Delete a user
      gtool user get USER        # Get a user
      gtool user groups USER     # Retrieve groups for a user
      gtool user help [COMMAND]  # Describe subcommands or one specific subcommand
      gtool user list            # List users
      gtool user update USER     # Update an existing user

- - -

**Organizational Units**

    % gtool orgunit
    Tasks:
      gtool orgunit get ORGUNIT     # Get an orgunit
      gtool orgunit help [COMMAND]  # Describe subcommands or one specific subcommand
      gtool orgunit list            # List organizational units

- - -

**Organizational Unit Members**

    % gtool orgmember
    Tasks:
      gtool orgmember get MEMBER                    # Retrieve a specific orgunit member
      gtool orgmember help [COMMAND]                # Describe subcommands or one specific subcommand
      gtool orgmember list                          # Get the members of an orgunit
      gtool orgmember move ORG_MEMBER, NEW_ORGUNIT  # Move an organization unit member

- - -

More complete documentation is pending on a more complete codebase.
