# Screens

This folder contains the main screen widgets for the OneMart SDUI app.

## Structure

- `home_screen.dart` - Main homepage screen
- `product_detail_screen.dart` - Product detail screen
- `category_screen.dart` - Category listing screen
- `search_screen.dart` - Search results screen
- `cart_screen.dart` - Shopping cart screen
- `profile_screen.dart` - User profile screen

## Guidelines

- Each screen should be a StatefulWidget or StatelessWidget
- Screens should use GetX for state management (Obx widgets)
- Screens should be responsive and work on different screen sizes
- Follow the established naming convention: `*_screen.dart`
- Keep business logic in controllers, not in screen widgets
- Use the widget components from the `../widgets/` folder for reusable UI elements
