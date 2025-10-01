import { Link } from 'react-router-dom';

function ArticleCard({ article }) {
  const formatDate = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric' 
    });
  };

  return (
    <Link to={`/article/${article.id}`} className="article-card">
      <div className="article-card-image">
        <img 
          src={article.image_url || 'https://via.placeholder.com/400x250'} 
          alt={article.title}
          loading="lazy"
        />
      </div>
      <div className="article-card-content">
        <h2 className="article-card-title">{article.title}</h2>
        <p className="article-card-description">{article.description}</p>
        <div className="article-card-meta">
          <span className="article-card-author">{article.author}</span>
          <span className="article-card-date">{formatDate(article.published_at)}</span>
        </div>
      </div>
    </Link>
  );
}

export default ArticleCard; 