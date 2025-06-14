from django.contrib import admin
from .models import Users, Foodcatalog, Foodcategories, Units, Recipes
import bcrypt

@admin.register(Users)
class UsersAdmin(admin.ModelAdmin):
    list_display = (
        'user_id', 'username', 'email', 'full_name', 'role', 'created_at', 'updated_at'
    )
    list_display_links = ('username',)
    search_fields = ('username', 'email', 'full_name', 'role')
    list_filter = ('role',)
    list_per_page = 20

    def save_model(self, request, obj, form, change):
        # Nếu password là plain text (không bắt đầu bằng '$2a$')
        if obj.password and not obj.password.startswith('$2a$'):
            obj.password = bcrypt.hashpw(obj.password.encode(), bcrypt.gensalt()).decode()
        super().save_model(request, obj, form, change)

@admin.register(Foodcatalog)
class FoodcatalogAdmin(admin.ModelAdmin):
    list_display = ('food_catalog_id', 'food_name', 'category', 'description')
    list_display_links = ('food_name',)
    search_fields = ('food_name', 'description')
    list_filter = ('category',)
    list_select_related = ('category',)
    list_per_page = 20

@admin.register(Foodcategories)
class FoodcategoriesAdmin(admin.ModelAdmin):
    list_display = ('category_id', 'category_name', 'description')
    list_display_links = ('category_name',)
    search_fields = ('category_name',)
    list_per_page = 20

@admin.register(Units)
class UnitsAdmin(admin.ModelAdmin):
    list_display = ('unit_id', 'unit_name', 'description', 'food_category')
    list_display_links = ('unit_name',)
    search_fields = ('unit_name', 'description')
    list_filter = ('food_category',)
    list_select_related = ('food_category',)
    list_per_page = 20

@admin.register(Recipes)
class RecipesAdmin(admin.ModelAdmin):
    list_display = ('recipe_id', 'recipe_name', 'description', 'instructions')
    list_display_links = ('recipe_name',)
    search_fields = ('recipe_name', 'description', 'instructions')
    list_per_page = 20



from django.contrib import admin
from django.contrib.auth.models import Group, User

admin.site.unregister(Group)
admin.site.unregister(User)
