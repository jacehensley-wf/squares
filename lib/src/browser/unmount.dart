part of squares_browser;

unmountComponent(html.Element mountRoot) {
  logger.fine("unmountComponent called");
  Node node = _elementToNode[mountRoot];
  if (node == null && mountRoot.children.length == 1) {
    node = _elementToNode[mountRoot.firstChild];
    while (node.parent != null) {
      node = node.parent;
    }
  }

  if (node != null) {
    _unmountNode(node);
    mountRoot.children.clear();
  }
}

_unmountNode(Node node) {
  logger.fine("_unmountNode called");
  /**
   * notify component, that will be unmounted
   */
  node.component.willUnmount();
  node.children.forEach((Node child) {
    _unmountNode(child);
  });
  _deleteRelations(node, _nodeToElement[node]);
}

