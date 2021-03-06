part of squares;

class DummyList{
  const DummyList();
  add(var elem) {}
}

// TODO: make changes parameter named
// TODO: is there any reason, why _updateChildren is not a method of Node class?
_updateChildren (Node node, {List<NodeChange> changes}) {
  logger.fine("_updateChildren called");
  /**
   * get old children from node, next children descriptions from component and prepare next children map
   */
  Map<dynamic, Node> oldChildren = _createChildrenMap(node.children);
  Map<dynamic, num> oldChildrenPositions = _createPositionMap(oldChildren.keys);
  List<Node> nextChildren = [];
  Iterable<ComponentDescription> descriptions = _getChildrenFromComponent(node.component);

  logger.finer('component: ${node.component.props}');

  var index = 0;
  descriptions.forEach((ComponentDescription description) {
    dynamic key = description.key;
    if (key == null) {
      key = index;
    }

    Node oldChild = oldChildren[key];
    Node nextChild;

    /**
     * if factory is same, just apply new props
     */
    if (oldChild != null && oldChild.factory == description.factory) {
      logger.finer('same factory, updating props');
      nextChild = oldChild;
      Map oldListeners = nextChild.listeners;
      nextChild.apply(props: description.props, children: description.children, listeners: description.listeners);
      if (index != oldChildrenPositions[key]) {
        _addChanges(new NodeChange(NodeChangeType.MOVED, nextChild), changes);
      }

      nextChild.update(changes: changes, force: true, oldListeners: oldListeners);
      oldChildren.remove(key);
    } else {
      logger.finer('different factory, create & delete');
      /**
       * else create new node and if necessery, remove old one
       */
      nextChild = new Node.fromDescription(node, description);
      nextChild.update();
      _addChanges(new NodeChange(NodeChangeType.CREATED, nextChild), changes);

      if (oldChild != null) {
        _addChanges(new NodeChange(NodeChangeType.DELETED, oldChild), changes);
        oldChildren.remove(key);
      }
    }
    nextChildren.add(nextChild);
    ++index;
  });
  for (Node child in oldChildren.values) {
    logger.finer("removin old child");
    _addChanges(new NodeChange(NodeChangeType.DELETED, child), changes);
  }

  node.children = nextChildren;
}

Map<dynamic, Node> _createChildrenMap (List<Node> nodes) {
  logger.finer("_createChildMap");
  Map result = {};
  num index = 0;
  for (Node node in nodes) {
    if (node.key != null) {
      result[node.key] = node;
    } else {
      result[index] = node;
    }
    index++;
  }
  logger.finer("_createChildMap created");
  return result;
}


Iterable<ComponentDescription> _getChildrenFromComponent(Component component) {
  logger.finer("_getChildrenFromComponent");
  var rawChildren = component.render();
  if (rawChildren is ComponentDescription) {
    /**
     * if render returns componentDescription, construct newChildren list
     */
    return [rawChildren];
  } else if (rawChildren is Iterable<ComponentDescription>) {
    /**
     * if render returns Iterable<componentDescription> set newChildren to it
     */
    return rawChildren;
  } else if (rawChildren == null) {
    /**
     * if component don't render anything and return null instead of empty list,
     * replace null with empty list.
     */
    return [];
  } else {
    /**
     * if it returns something else, throw exception
     */
    throw "render should return ComponentDescription or Iterable<ComponentDescription>";
  }
}

Map<dynamic, num> _createPositionMap(Iterable<dynamic> input) {
  Map<dynamic, num> result = {};
  var i = 0;
  for (var value in input) {
    result[value] = i;
    ++i;
  }
  return result;
}

