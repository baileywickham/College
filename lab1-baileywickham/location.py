# CPE 202 Lab 0

# represents a location using name, latitude and longitude
class Location:
    def __init__(self, name, lat, lon):
        self.name = name    # string for name of location
        self.lat = lat      # latitude in degrees (-90 to 90)
        self.lon = lon      # longitude in degrees (-180 to 180)

# ADD BOILERPLATE HERE (__eq__ and __repr__ functions)
    def __eq__(self, comp):
        return (type(self) == type(comp) and self.name == comp.name and self.lat == comp.lat and self.lon == comp.lon)

    def __repr__(self):
        # from my understanding this is the string represetation of the data?
        return f"Location('{self.name}', {self.lat}, {self.lon})" 
