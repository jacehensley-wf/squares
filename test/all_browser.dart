library tiles_test;

import 'browser/mount_component_test.dart' as mountComponent;
import 'browser/mount_lifecycle_test.dart' as mountLifecycle;
import 'browser/update_component_test.dart' as updateComponent;
import 'browser/events_test.dart' as events;
import 'browser/keys_test.dart' as keys;
import 'browser/special_attributes_test.dart' as specialAttributes;
import 'browser/elements.dart' as elements;

main () {
  mountComponent.main();
  mountLifecycle.main();
  updateComponent.main();
  events.main();
  keys.main();
  specialAttributes.main();
  elements.main();
}
