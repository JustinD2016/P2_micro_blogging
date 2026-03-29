Members and Contributions:
Keaton Brown: Implementation of polls feature, allowing users to create polls with questions and multiple answers
for users to vote on.
Justin Dorval: Made majority of the app function initially and added important databases.
Aaryan Gupta: README, ER diagram, and final submission.
Connor Ray: Hashtag system allowing users to include hashtags on posts and search for posts based on hashtags.
Hashtags are now stored separately in the database instead of being a part of the post text.
Jacob Stewart: Formatted dates, fixed the homepage only showing followed people.

New Feature: Polls
Allows the user to create polls, enter answer options, view existing polls, and vote in the poll.

How to run the project: 
Database Setup: 
1) Start MySQL
2) Run database_setup.sql
This creates the database csx370_mb_platform to use

Where to locate code for the new feature:
UI:
- src/main/resources/templates/polls_page.mustache
- src/main/resources/templates/fragments/
Controller:
- src/main/java/uga/menik/csx370/controllers/PollsController.java
Service:
- Poll-related logic is primarily handled in the controller, while user/session support uses the existing service layer such as:
- src/main/java/uga/menik/csx370/services/UserService.java
SQL/Schema Additions:
- database_setup.sql

To run:
1) Clone the repo
2) Move into the project directory (P2_micro_blogging)
3) Run the application
4) Open app in a browser
