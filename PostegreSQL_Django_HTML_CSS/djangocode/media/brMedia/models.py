from django.db import models

class Person(models.Model):
    name = models.CharField(max_length=255, null=False, blank=False)
    email = models.EmailField(unique=True, max_length=255, blank=True)
    password = models.CharField(max_length=255, null=False, blank=True)

    def __str__(self):
        return f"Username: {self.name} for email: {self.email}"


class Genre(models.Model):
    name = models.CharField(max_length=255, null=True, blank=True)
    description = models.CharField(max_length=512, null=True, blank=True)

    def __str__(self):
        return f"Genre: {self.name}" if self.name else "Unnamed Genre"


class Director(models.Model):
    name = models.CharField(max_length=255, null=True, blank=True)
    birth_date = models.DateField(null=True, blank=True)
    nationality = models.CharField(max_length=255, null=True, blank=True)

    def __str__(self):
        return f"Director: {self.name}" if self.name else "Unnamed Director"


class Actor(models.Model):
    name = models.CharField(max_length=255, null=True, blank=True)
    birth_date = models.DateField(null=True, blank=True)
    nationality = models.CharField(max_length=100, null=True, blank=True)

    def __str__(self):
        return f"Actor:{self.name}" if self.name else "Unnamed Actor"


class Media(models.Model):
    title = models.CharField(max_length=255, null=False, blank=False)
    media_type = models.CharField(max_length=10, choices=[('serie', 'Serie'), ('film', 'Film')])
    release_date = models.DateField(null=True, blank=True)
    synopsis = models.CharField(max_length=512, null=False, blank=False)
    directors = models.ManyToManyField(Director, related_name='media_director', blank=True)
    actors = models.ManyToManyField(Actor, related_name='media_actor', blank=True)
    genre = models.ManyToManyField(Genre, related_name='media_genre', blank=True)

    class Meta:
        abstract = False

    def __str__(self):
        if self.title:
            return f"{self.media_type}: {self.title} released on {self.release_date}"
        return 'Untitled media'


class Film(Media):
    duration = models.CharField(max_length=255, null=True, blank=True)

    def __str__(self):
        return f"Film: {self.title}" if self.title else "Unnamed Film"


class Series(Media):
    seasons = models.IntegerField(null=True, blank=True)
    episodes = models.IntegerField(null=True, blank=True)

    def __str__(self):
        return f"Serie: {self.title}" if self.title else "Unnamed Series"


class Visualization(models.Model):
    person = models.ForeignKey(Person, on_delete=models.CASCADE)
    media = models.ForeignKey(Media, on_delete=models.CASCADE)
    view_date = models.DateField(null=True, blank=True)

    def __str__(self):
        if self.person and self.media:
            return f"{self.person.name} viewed {self.media.title} on {self.view_date}"
        return "Unnamed Visualization"


class Review(models.Model):
    person = models.ForeignKey(Person, on_delete=models.CASCADE)
    media = models.ForeignKey(Media, on_delete=models.CASCADE)
    rev_date = models.DateField(null=True, blank=True)
    rating = models.IntegerField(null=True, blank=True)
    comment = models.CharField(max_length=512, null=True, blank=True)

    def __str__(self):
        if self.person and self.media:
            return f"Review by {self.person.name} for {self.media.title} on {self.rev_date}"
        return "Unnamed Review"  

        