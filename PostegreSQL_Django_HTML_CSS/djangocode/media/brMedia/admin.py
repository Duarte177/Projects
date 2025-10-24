from django.contrib import admin
from import_export.admin import ImportExportModelAdmin

# Register your models here.
from .models import Person
from .models import Visualization
from .models import Review
from .models import Media
from .models import Film
from .models import Series
from .models import Genre
from .models import Director
from .models import Actor

admin.site.register(Person)
admin.site.register(Visualization)
admin.site.register(Review)
admin.site.register(Media)
admin.site.register(Film)
admin.site.register(Series)
admin.site.register(Genre)
admin.site.register(Director)
admin.site.register(Actor)

