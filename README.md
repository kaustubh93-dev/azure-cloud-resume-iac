# Azure Cloud Resume Website

A modern, responsive resume website built following the **Azure Cloud Resume Challenge**. This project demonstrates full-stack development skills, cloud architecture knowledge, and modern DevOps practices.

## 🚀 Live Demo

[Visit the Live Site](https://yoursite.azurewebsites.net) 

## 🏗️ Architecture

### Frontend
- **HTML5**: Semantic markup with accessibility features
- **CSS3**: Modern CSS with CSS Grid, Flexbox, and CSS Custom Properties
- **Vanilla JavaScript**: Theme switching, visitor counter, smooth animations
- **Responsive Design**: Mobile-first approach with CSS Grid and Flexbox

### Backend
- **Azure Functions**: Serverless API endpoints (Python)
- **Azure Cosmos DB**: NoSQL database for visitor counter
- **Azure Storage**: Static website hosting

### Infrastructure
- **Azure CDN**: Global content delivery
- **Azure Resource Manager**: Infrastructure as Code
- **GitHub Actions**: CI/CD pipeline

## 📁 Project Structure

```
azure-resume-website/
├── frontend/src/
│   ├── index.html              # Main HTML file
│   └── assets/
│       ├── css/style.css       # Main stylesheet
│       └── js/script.js        # JavaScript functionality
├── backend/src/functions/      # Azure Functions
├── infrastructure/             # Infrastructure as Code
├── tests/                      # Testing files
└── docs/                       # Documentation
```

## 🛠️ Technologies Used

**Frontend:**
- HTML5, CSS3, JavaScript (ES6+)
- CSS Grid & Flexbox for layout
- CSS Custom Properties for theming
- Web API (Fetch, localStorage)

**Backend:**
- Azure Functions (Python)
- Azure Cosmos DB
- Azure Storage Account

**DevOps:**
- GitHub Actions for CI/CD
- Azure Resource Manager templates
- Azure CLI for deployment

## ⚡ Features

- **Responsive Design**: Works perfectly on all devices
- **Dark/Light Theme**: Toggle with persistence
- **Dynamic Visitor Counter**: Real-time visitor tracking
- **Modern UI**: GitHub-inspired minimalist design
- **Fast Loading**: Optimized performance
- **SEO Friendly**: Proper meta tags and semantic HTML

## 🚀 Local Development

### Prerequisites
- Node.js (optional, for build tools)
- Azure CLI
- Azure Functions Core Tools
- Python 3.8+ (for backend functions)

### Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/azure-resume-website.git
   cd azure-resume-website
   ```

2. **Frontend Development:**
   - Open `frontend/src/index.html` in your browser
   - Or use a local server:
     ```bash
     cd frontend/src
     python -m http.server 8000
     # Visit http://localhost:8000
     ```

3. **Backend Development:**
   ```bash
   cd backend/src
   pip install -r requirements.txt
   func start
   ```

## 📦 Deployment

### Frontend Deployment (Azure Storage)
```bash
# Upload to Azure Storage Static Website
az storage blob upload-batch -s frontend/src -d '$web' --account-name yourstorageaccount
```

### Backend Deployment (Azure Functions)
```bash
# Deploy Azure Functions
cd backend/src
func azure functionapp publish your-function-app
```

### Infrastructure Deployment
```bash
# Deploy using Azure Resource Manager
az deployment group create --resource-group your-rg --template-file infrastructure/main.json
```

## 🎯 Azure Cloud Resume Challenge

This project fulfills all requirements of the Azure Cloud Resume Challenge:

- [x] **HTML/CSS**: Modern, responsive resume website
- [x] **Static Website**: Hosted on Azure Storage
- [x] **HTTPS**: Custom domain with SSL certificate
- [x] **DNS**: Custom domain configuration
- [x] **JavaScript**: Interactive visitor counter
- [x] **Database**: Azure Cosmos DB for data persistence
- [x] **API**: Azure Functions for backend logic
- [x] **Python**: Backend functions written in Python
- [x] **Tests**: Unit and integration tests
- [x] **Infrastructure as Code**: ARM templates/Bicep
- [x] **CI/CD**: GitHub Actions pipeline
- [x] **Blog Post**: [Read about the project](https://yourblog.com/azure-resume-challenge)

## 🧪 Testing

```bash
# Run frontend tests
npm test

# Run backend tests
cd backend
python -m pytest tests/
```

## 🔒 Security

- CORS properly configured for API endpoints
- Input validation on all user inputs
- Secure headers implemented
- Environment variables for sensitive data

## 📈 Performance

- **Lighthouse Score**: 95+ across all metrics
- **First Contentful Paint**: < 1.5s
- **Cumulative Layout Shift**: < 0.1
- **Time to Interactive**: < 3s

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Contact

Alex Rodriguez - [@alexrodriguez](https://linkedin.com/in/alexrodriguez) - alex@alexrodriguez.dev

Project Link: [https://github.com/alexrodriguez/azure-resume-website](https://github.com/alexrodriguez/azure-resume-website)

---

**Built with ❤️ for the Azure Cloud Resume Challenge**