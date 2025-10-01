const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://api.fastnews.local';

class ApiService {
  async getArticles() {
    const response = await fetch(`${API_BASE_URL}/api/articles`);
    if (!response.ok) {
      throw new Error('Failed to fetch articles');
    }
    return response.json();
  }

  async getArticle(id) {
    const response = await fetch(`${API_BASE_URL}/api/articles/${id}`);
    if (!response.ok) {
      throw new Error('Failed to fetch article');
    }
    return response.json();
  }

  async createArticle(article) {
    const response = await fetch(`${API_BASE_URL}/api/articles`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(article),
    });
    if (!response.ok) {
      throw new Error('Failed to create article');
    }
    return response.json();
  }

  async updateArticle(id, article) {
    const response = await fetch(`${API_BASE_URL}/api/articles/${id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(article),
    });
    if (!response.ok) {
      throw new Error('Failed to update article');
    }
    return response.json();
  }

  async deleteArticle(id) {
    const response = await fetch(`${API_BASE_URL}/api/articles/${id}`, {
      method: 'DELETE',
    });
    if (!response.ok) {
      throw new Error('Failed to delete article');
    }
    return response.json();
  }
}

export default new ApiService(); 