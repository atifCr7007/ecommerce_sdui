# JSON UI Definitions

This folder contains Server-Driven UI (SDUI) definitions for the ecommerce app.

## Structure

- `home_page.json` - Homepage layout and components
- `product_detail.json` - Product detail page layout
- `category_page.json` - Category listing page layout
- `search_page.json` - Search results page layout

## Usage

These JSON files define the UI structure that gets parsed by the `JsonParser` and rendered dynamically by the `WidgetMapper`. This allows for:

- Dynamic UI updates without app releases
- A/B testing of different layouts
- Consistent UI structure across platforms
- Easy customization and theming

## JSON Structure

Each JSON file follows this basic structure:

```json
{
  "screenId": "unique_screen_identifier",
  "title": "Screen Title",
  "theme": {
    "primaryColor": "#2196F3",
    "secondaryColor": "#FF5722",
    "backgroundColor": "#FFFFFF"
  },
  "components": [
    {
      "type": "component_type",
      "id": "unique_component_id",
      "properties": {
        // Component-specific properties
      },
      "children": [
        // Nested components
      ]
    }
  ]
}
```

## Supported Components

- `column` - Vertical layout
- `row` - Horizontal layout
- `container` - Container with styling
- `text` - Text display
- `button` - Interactive button
- `image` - Image display
- `productlist` - Product grid/list
- `banner` - Promotional banner
- `carousel` - Image carousel
- `sizedbox` - Spacing element
- `divider` - Visual separator

## Development Notes

- Always validate JSON syntax before deployment
- Test UI changes across different screen sizes
- Ensure all referenced assets are available
- Follow consistent naming conventions for IDs
