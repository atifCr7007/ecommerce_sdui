import 'package:get/get.dart';

/// Controller to manage expandable section states globally
class ExpandableSectionController extends GetxController {
  // Map to store expanded states for different sections
  final RxMap<String, bool> _expandedStates = <String, bool>{}.obs;

  /// Get the expanded state for a section
  bool isExpanded(String sectionId) {
    return _expandedStates[sectionId] ?? false;
  }

  /// Toggle the expanded state for a section
  void toggleSection(String sectionId) {
    _expandedStates[sectionId] = !isExpanded(sectionId);
  }

  /// Set the expanded state for a section
  void setExpanded(String sectionId, bool expanded) {
    _expandedStates[sectionId] = expanded;
  }

  /// Initialize a section with default state
  void initializeSection(String sectionId, bool defaultExpanded) {
    if (!_expandedStates.containsKey(sectionId)) {
      _expandedStates[sectionId] = defaultExpanded;
    }
  }

  /// Get all expanded states (for debugging)
  Map<String, bool> get allStates => Map.from(_expandedStates);

  /// Clear all states
  void clearAll() {
    _expandedStates.clear();
  }
}
