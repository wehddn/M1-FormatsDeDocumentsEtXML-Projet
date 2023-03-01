import csv
import xml.etree.ElementTree as ET

# read nodes
with open('treeoflife_nodes.csv', 'r') as f:
    reader = csv.reader(f)
    next(reader)
    node_labels = {row[0]: row[1] for row in reader}

# read edges
with open('treeoflife_links.csv', 'r') as f:
    reader = csv.reader(f)
    next(reader)
    edges = [row for row in reader]

# new tree in the form of a dictionary, where key - node, value - list of childs
tree = {}
for edge in edges:
    parent, child = edge
    if parent in tree:
        tree[parent].append(child)
    else:
        tree[parent] = [child]


# recursively adding nodes to the tree
def add_node(parent_element, node_label):
    node_element = ET.SubElement(parent_element, 'node', label=node_label)
    if node_label in tree:
        for child_label in tree[node_label]:
            add_node(node_element, child_label)


root = ET.Element('tree')

# adding all nodes to the tree starting from the root element
for node_label in tree:
    if node_label not in node_labels:
        continue
    if not any(child == node_label for parent, child in edges):
        add_node(root, node_label)

tree_xml = ET.ElementTree(root)
ET.indent(tree_xml, '  ')
tree_xml.write('tree.xml')
