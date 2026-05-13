<?php 
include 'db.php';
$id = (int)$_GET['id'];

// Handle Add to My List
if(isset($_POST['add']) && isset($_SESSION['user_id'])) {
    $uid = $_SESSION['user_id'];
    $stmt = mysqli_prepare($link, "INSERT IGNORE INTO mylist (user_id, recipe_id) VALUES (?, ?)");
    mysqli_stmt_bind_param($stmt, "ii", $uid, $id);
    mysqli_stmt_execute($stmt);
    header("Location: recipe.php?id=$id");
    exit();
}

// Handle Remove from My List
if(isset($_POST['remove']) && isset($_SESSION['user_id'])) {
    $uid = $_SESSION['user_id'];
    $stmt = mysqli_prepare($link, "DELETE FROM mylist WHERE user_id=? AND recipe_id=?");
    mysqli_stmt_bind_param($stmt, "ii", $uid, $id);
    mysqli_stmt_execute($stmt);
    header("Location: recipe.php?id=$id");
    exit();
}

$stmt = mysqli_prepare($link, "SELECT * FROM recipes WHERE id=?");
mysqli_stmt_bind_param($stmt, "i", $id);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);
$recipe = mysqli_fetch_assoc($result);
if(!$recipe) { die("Recipe not found"); }

// Check if already in user's list
$in_list = false;
if(isset($_SESSION['user_id'])) {
    $uid = $_SESSION['user_id'];
    $chk = mysqli_prepare($link, "SELECT id FROM mylist WHERE user_id=? AND recipe_id=?");
    mysqli_stmt_bind_param($chk, "ii", $uid, $id);
    mysqli_stmt_execute($chk);
    $in_list = mysqli_num_rows(mysqli_stmt_get_result($chk)) > 0;
}
?>
<!DOCTYPE html>
<html>
<head>
    <title><?php echo htmlspecialchars($recipe['title']); ?> | RecipeFlix</title>
    <link rel="stylesheet" href="style.css">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Montserrat:wght@400;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <?php include 'navbar.php'; ?>
    <div class="recipe-page">
        <div class="recipe-hero" style="background-image: url('<?php echo htmlspecialchars($recipe['image_url']); ?>')">
            <h1><?php echo htmlspecialchars($recipe['title']); ?></h1>
        </div>
        <div class="recipe-content">
            <div class="recipe-meta">
                <span>⏱ <?php echo htmlspecialchars($recipe['cooking_time']); ?></span>
                <span>📊 <?php echo htmlspecialchars($recipe['difficulty']); ?></span>
                <span>🍽 <?php echo htmlspecialchars($recipe['category']); ?></span>
            </div>
            <p class="desc"><?php echo htmlspecialchars($recipe['description']); ?></p>

            <?php if(isset($_SESSION['user_id'])): ?>
            <form method="POST" style="margin-top:20px;">
                <?php if($in_list): ?>
                    <button type="submit" name="remove" class="btn-info" style="border:none;cursor:pointer;">✕ Remove from My List</button>
                <?php else: ?>
                    <button type="submit" name="add" class="btn-play" style="border:none;cursor:pointer;">+ Add to My List</button>
                <?php endif; ?>
            </form>
            <?php endif; ?>

            <h3>Ingredients</h3>
            <pre><?php echo htmlspecialchars($recipe['ingredients']); ?></pre>
            <h3>Instructions</h3>
            <pre><?php echo htmlspecialchars($recipe['instructions']); ?></pre>
        </div>
    </div>
</body>
</html>