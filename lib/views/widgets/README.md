# Widgets

This folder contains reusable widget components for the OneMart SDUI app.

## Structure

- `product_card.dart` - Product display card widget
- `category_card.dart` - Category display card widget
- `banner_widget.dart` - Promotional banner widget
- `carousel_widget.dart` - Image carousel widget
- `loading_widget.dart` - Loading indicator widgets
- `error_widget.dart` - Error display widgets
- `empty_state_widget.dart` - Empty state display widgets

## Guidelines

- Widgets should be reusable across multiple screens
- Each widget should be self-contained and configurable via parameters
- Use GetX observables (Obx) for reactive updates when needed
- Follow the established naming convention: `*_widget.dart`
- Include proper documentation and examples for complex widgets
- Ensure widgets are accessible and follow Material Design guidelines
- Test widgets across different screen sizes and orientations
