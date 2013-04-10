from slot import slot
class dev:
    def __init__(self,name,properties):
        self.name = name
        self.properties = properties
        self.bandwidth = self.properties["total-bandwidth"]
        self.slots = []
        for i,j in self.properties["slots"].items():
            self.slots.append(slot(i,j))
