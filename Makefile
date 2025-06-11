.PHONY: all render install server clean serve-pdf deploy

# Define variables
# MARP_CLI_VERSION = latest # or a specific version like 2.2.0
PRESENTATION_FILE = presentation.md
OUTPUT_PDF = presentation.pdf
OUTPUT_HTML = presentation.html
OUTPUT_PPTX = presentation.pptx
DOCS_DIR = docs

# Default target
all: render

# Install Marp CLI dependency
install:
	@echo "Installing Marp CLI..."
	npm install -g @marp-team/marp-cli
	@echo "Marp CLI installed globally."

# Render the presentation to PDF, HTML, and PPTX
render:
	@echo "Rendering presentation to PDF, HTML, and PPTX..."
	marp $(PRESENTATION_FILE) -o $(OUTPUT_PDF) --allow-local-files
	marp $(PRESENTATION_FILE) -o $(OUTPUT_HTML) --allow-local-files
	marp $(PRESENTATION_FILE) -o $(OUTPUT_PPTX) --allow-local-files
	@echo "Presentation rendered successfully."

# Start watching for changes and re-render PDF
serve:
	@echo "Cleaning old PDF..."
	rm -f $(OUTPUT_PDF)
	@echo "Building initial PDF..."
	marp --allow-local-files $(PRESENTATION_FILE) -o $(OUTPUT_PDF) --no-stdin
	@echo "Starting PDF auto-renderer..."
	@echo "Watching $(PRESENTATION_FILE) for changes..."
	@echo "Press Ctrl+C to stop"
	fswatch -o $(PRESENTATION_FILE) | while read; do \
		echo "Changes detected, re-rendering PDF..."; \
		marp --allow-local-files $(PRESENTATION_FILE) -o $(OUTPUT_PDF) --no-stdin; \
		echo "PDF updated at $$(date)"; \
	done

# Deploy to GitHub Pages
deploy:
	@echo "Creating docs directory..."
	mkdir -p $(DOCS_DIR)
	@echo "Copying assets..."
	cp -r figures $(DOCS_DIR)/
	cp *.jpg $(DOCS_DIR)/ 2>/dev/null || true
	cp *.png $(DOCS_DIR)/ 2>/dev/null || true
	@echo "Rendering presentation to docs directory..."
	marp $(PRESENTATION_FILE) -o $(DOCS_DIR)/index.html --allow-local-files
	@echo "Deployment files ready in $(DOCS_DIR) directory."

# Clean up generated output files
clean:
	@echo "Cleaning up generated files..."
	rm -f $(OUTPUT_PDF) $(OUTPUT_HTML) $(OUTPUT_PPTX)
	rm -rf $(DOCS_DIR)
	@echo "Clean up complete."