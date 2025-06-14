from django.db import models

class Users(models.Model):
    user_id = models.AutoField(primary_key=True)
    username = models.CharField(unique=True, max_length=50)
    password = models.CharField(max_length=255)
    email = models.CharField(unique=True, max_length=100)
    full_name = models.CharField(max_length=100, blank=True, null=True)
    role = models.CharField(max_length=5, blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    class Meta:

        db_table = 'users'

    def __str__(self):
        return f"{self.username} ({self.email})"

class Foodcategories(models.Model):
    category_id = models.AutoField(primary_key=True)
    category_name = models.CharField(max_length=100)
    description = models.TextField(blank=True, null=True)

    class Meta:

        db_table = 'foodcategories'

    def __str__(self):
        return self.category_name

class Units(models.Model):
    unit_id = models.AutoField(primary_key=True)
    unit_name = models.CharField(max_length=50)
    description = models.TextField(blank=True, null=True)
    food_category = models.ForeignKey(Foodcategories, models.DO_NOTHING, db_column='food_category_id', blank=True, null=True)

    class Meta:
        
        db_table = 'units'

    def __str__(self):
        return self.unit_name

class Foodcatalog(models.Model):
    food_catalog_id = models.AutoField(primary_key=True)
    food_name = models.CharField(max_length=100)
    category = models.ForeignKey(Foodcategories, models.DO_NOTHING, db_column='category_id', blank=True, null=True)
    description = models.TextField(blank=True, null=True)

    class Meta:
       
        db_table = 'foodcatalog'

    def __str__(self):
        return self.food_name
    
class Recipes(models.Model):
    recipe_id = models.AutoField(primary_key=True)
    recipe_name = models.CharField(max_length=100)
    description = models.TextField(blank=True, null=True)
    instructions = models.TextField(blank=True, null=True)

    class Meta:
        
        db_table = 'recipes'

    def __str__(self):
        return self.recipe_name
    