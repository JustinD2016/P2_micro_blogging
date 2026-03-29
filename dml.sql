-- Purpose: This query populates the bookmark page with the post information that a user has bookmarked. 
-- It displays all the post information including likes, comments, and post date. 
-- URL: http://localhost:8081/bookmarks
final String sql = "SELECT " +
            "p.postId, " +
            "p.userId, " +
            "u.firstName, " +
            "u.lastName, " +
            "p.content, " +
            "DATE_FORMAT(p.postDate, '%b %d, %Y, %h:%i%p') AS postDate,  " +
            "(SELECT COUNT(*) FROM heart h WHERE h.postId = p.postId) AS heartsCount, " +
            "(SELECT COUNT(*) FROM comment c WHERE c.postId = p.postId) AS commentsCount, " +
            "(SELECT COUNT(*) FROM bookmark b WHERE b.postId = p.postId AND b.userId = ?) AS isBookmarked, " +
            "(SELECT COUNT(*) FROM heart h WHERE h.postId = p.postId AND h.userId = ?) AS isHearted " +
            "FROM post p " +
            "JOIN user u ON p.userId = u.userId " +
            "WHERE p.postId IN (SELECT postId FROM bookmark WHERE userId = ?) " +
            "ORDER BY p.postDate DESC";;

-- Purpose: Queries all of the posts that have the searched hashtags entered by the user. Query also includes all the 
-- post information of the posts with the searches hashtags. 
-- URL: http://localhost:8081/hashtagsearch?hashtags=%
 final String sql =
                "SELECT " +
                "p.postId, " +
                "p.userId, " +
                "u.firstName, " +
                "u.lastName, " +
                "p.content, " +
                "DATE_FORMAT(p.postDate, '%b %d, %Y, %h:%i %p') AS postDate, " +
                "(SELECT COUNT(*) FROM heart h WHERE h.postId = p.postId) AS heartsCount, " +
                "(SELECT COUNT(*) FROM comment c WHERE c.postId = p.postId) AS commentsCount, " +
                "(CASE WHEN EXISTS (SELECT 1 FROM heart h2 WHERE h2.postId = p.postId AND h2.userId = ?) THEN true ELSE false END) AS isHearted, " +
                "(CASE WHEN EXISTS (SELECT 1 FROM bookmark b WHERE b.postId = p.postId AND b.userId = ?) THEN true ELSE false END) AS isBookmarked " +
                "FROM post p " +
                "JOIN user u ON p.userId = u.userId " +
                "JOIN post_hashtag ph ON p.postId = ph.postId " +
                "JOIN hashtag ht ON ph.hashtagId = ht.hashtagId " +
                "WHERE ht.tag IN (" + placeholders + ") " +
                "GROUP BY p.postId, p.userId, u.firstName, u.lastName, p.content, p.postDate " +
                "HAVING COUNT(DISTINCT ht.tag) = ? " +
                "ORDER BY p.postDate DESC";

-- Purpose: This query populates the posts and detailed information about the posts of people that the logged in user follows. 
-- URL: http://localhost:8081/
final String sql = "SELECT " +
            "p.postId, " +
            "p.userId, " +
            "u.firstName, " +
            "u.lastName, " +
            "p.content, " +
            "DATE_FORMAT(p.postDate, '%b %d, %Y, %h:%i%p') AS postDate, " +
            "(SELECT COUNT(*) FROM heart h WHERE h.postId = p.postId) AS heartsCount, " +
            "(SELECT COUNT(*) FROM comment c WHERE c.postId = p.postId) AS commentsCount, " +
            "(SELECT COUNT(*) FROM bookmark b WHERE b.postId = p.postId AND b.userId = ?) AS isBookmarked, " +
            "(SELECT COUNT(*) FROM heart h WHERE h.postId = p.postId AND h.userId = ?) AS isHearted " +
            "FROM post p " +
            "JOIN user u ON p.userId = u.userId " +
            "WHERE p.userID IN (SELECT followerID FROM follow WHERE followeeID = ?)" +
            "ORDER BY p.postDate DESC";

-- Purpose: This query pulls all the detail about the post that the user is attempting to view. Includes content of post, 
-- date, author information, and interactions. 
-- URL: http://localhost:8081/post/
final String sql = "SELECT " +
            "p.postId, " +
            "p.userId, " +
            "u.firstName, " +
            "u.lastName, " +
            "p.content, " +
            "DATE_FORMAT(p.postDate, '%b %d, %Y, %h:%i%p') AS postDate, " +
            "(SELECT COUNT(*) FROM heart h WHERE h.postId = p.postId) AS heartsCount, " +
            "(SELECT COUNT(*) FROM comment c WHERE c.postId = p.postId) AS commentsCount, " +
            "(CASE WHEN EXISTS (SELECT 1 FROM heart h2 WHERE h2.postId = p.postId AND h2.userId = ?) THEN true ELSE false END) AS isHearted, " +
            "(CASE WHEN EXISTS (SELECT 1 FROM bookmark b WHERE b.postId = p.postId AND b.userId = ?) THEN true ELSE false END) AS isBookmarked " +
            "FROM post p JOIN user u ON p.userId = u.userId WHERE p.postId = ?";


-- Purpose: This query gathers all of the posts made by the logged in user and shows all the each posts information.
-- All of the posts are order from most recent to oldest. It also shows how the logged in user has interacted with the post. 
-- URL: http://localhost:8081/profile
final String sql = "SELECT " +
            "p.postId, " +
            "p.userId, " +
            "u.firstName, " +
            "u.lastName, " +
            "p.content, " +
            "DATE_FORMAT(p.postDate, '%b %d, %Y, %h:%i%p') AS postDate,  " +
            "(SELECT COUNT(*) FROM heart h WHERE h.postId = p.postId) AS heartsCount, " +
            "(SELECT COUNT(*) FROM comment c WHERE c.postId = p.postId) AS commentsCount, " +
            "(CASE WHEN EXISTS (SELECT 1 FROM heart h2 WHERE h2.postId = p.postId AND h2.userId = ?) THEN true ELSE false END) AS isHearted, " +
            "(CASE WHEN EXISTS (SELECT 1 FROM bookmark b WHERE b.postId = p.postId AND b.userId = ?) THEN true ELSE false END) AS isBookmarked " +
            "FROM post p JOIN user u ON p.userId = u.userId WHERE p.userId = ? ORDER BY p.postDate DESC";


-- Purpose: This query gathers all of the users that the logged in user can follow which excludes the logged in user and users that 
-- the logged in user already follows. It also each of the followable users most recent post date. 
-- URL: http://localhost:8081/people
        final String sql = "SELECT u.userId, u.firstName, u.lastName, COALESCE(DATE_FORMAT(lastPost.lastPostDate, '%b %d, %Y, %h:%i%p'), 'No posts yet') AS lastPostDate " + 
                            "FROM user u " + 
                            "LEFT JOIN "  + 
                            "(SELECT p.userId, MAX(p.postDate) AS lastPostDate " +
                            "FROM post p " + 
                            "GROUP BY p.userId)  lastPost ON u.userId = lastPost.userId " +
                            "WHERE u.userId != ? AND u.userId NOT IN (SELECT followerId FROM follow WHERE followeeId = ?)";