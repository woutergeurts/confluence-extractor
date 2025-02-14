import json
import logging

class Page:
    def __init__(self, page_id, title:str, labels=None):
        self.page_id = page_id
        self.title = title
        self.labels = set(labels) if labels else set()
        self.children = []

    def add_child(self, child_page):
        """Adds a child page to the current page."""
        self.children.append(child_page)
   
    def log_tree(self, level=0):
        """dumps tree to info logging the page titles hierarchically with indentation."""
        logging.info("  " * level + self.title)
        for child in self.children:
            child.log_tree(level + 1)

    def find_by_id(self, page_id) -> "Page | None":
        """Finds and returns the page with the given page_id."""
        if self.page_id == page_id:
            return self
        for child in self.children:
            found = child.find_by_id(page_id)
            if found:
                return found
        return None
    
    def dump(self, filename):
        """Dumps the tree to a file."""
        def serialize(page):
            return {
                "page_id": page.page_id,
                "title": page.title,
                "labels": list(page.labels),
                "children": [serialize(child) for child in page.children]
            }
        with open(filename, "w") as f:
            json.dump(serialize(self), f, indent=4)
    
    @staticmethod
    def undump(filename):
        """Reads the tree from a file."""
        def deserialize(data):
            page = Page(data["page_id"], data["title"], data["labels"])
            page.children = [deserialize(child) for child in data["children"]]
            return page
        with open(filename, "r") as f:
            return deserialize(json.load(f))

# small test to demonstrate the class usage
if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    root = Page(1, "Home")
    about = Page(2, "About")
    services = Page(3, "Services")
    contact = Page(4, "Contact")
    web_dev = Page(5, "Web Development")
    seo = Page(6, "SEO")
    
    services.add_child(web_dev)
    services.add_child(seo)
    root.add_child(about)
    root.add_child(services)
    root.add_child(contact)

    logging.debug("home_tree")
    root.log_tree()
    root.dump("tree.json")
    
    logging.debug("services_subtree")
    services_subtree = root.find_by_id(3)
    services_subtree.log_tree()

    loaded_root = Page.undump("tree.json")
    loaded_root.log_tree()
