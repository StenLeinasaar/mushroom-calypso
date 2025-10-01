import { useState, useEffect } from 'react';
import { useParams, Link, useNavigate } from 'react-router-dom';
import api from '../services/api';

function ArticleDetail() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [article, setArticle] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    loadArticle();
  }, [id]);

  const loadArticle = async () => {
    try {
      setLoading(true);
      const data = await api.getArticle(id);
      setArticle(data);
      setError(null);
    } catch (err) {
      setError('Failed to load article. Please try again later.');
      console.error('Error loading article:', err);
    } finally {
      setLoading(false);
    }
  };

  const formatDate = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  if (loading) {
    return <div className="loading">Loading article...</div>;
  }

  if (error || !article) {
    return (
      <div className="error">
        <p>{error || 'Article not found'}</p>
        <button onClick={() => navigate('/')}>Back to Home</button>
      </div>
    );
  }

  return (
    <div className="article-detail-container">
      <Link to="/" className="back-link">← Back to Articles</Link>
      
      <article className="article-detail">
        <header className="article-header">
          <h1 className="article-title">{article.title}</h1>
          <div className="article-meta">
            <span className="article-author">By {article.author}</span>
            <span className="article-date">{formatDate(article.published_at)}</span>
          </div>
        </header>

        {article.image_url && (
          <div className="article-image">
            <img src={article.image_url} alt={article.title} />
          </div>
        )}

        {article.description && (
          <p className="article-description">{article.description}</p>
        )}

        <div className="article-content">
          <p>{article.content}</p>
        </div>
      </article>
    </div>
  );
}

export default ArticleDetail; 