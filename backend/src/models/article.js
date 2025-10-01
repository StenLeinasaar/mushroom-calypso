const pool = require('../config/database');

class Article {
  static async getAll() {
    const query = 'SELECT * FROM articles ORDER BY published_at DESC';
    const result = await pool.query(query);
    return result.rows;
  }

  static async getById(id) {
    const query = 'SELECT * FROM articles WHERE id = $1';
    const result = await pool.query(query, [id]);
    return result.rows[0];
  }

  static async create(article) {
    const query = `
      INSERT INTO articles (title, description, content, author, image_url, published_at)
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING *
    `;
    const values = [
      article.title,
      article.description,
      article.content,
      article.author,
      article.image_url,
      article.published_at || new Date()
    ];
    const result = await pool.query(query, values);
    return result.rows[0];
  }

  static async update(id, article) {
    const query = `
      UPDATE articles
      SET title = $1, description = $2, content = $3, author = $4, image_url = $5
      WHERE id = $6
      RETURNING *
    `;
    const values = [
      article.title,
      article.description,
      article.content,
      article.author,
      article.image_url,
      id
    ];
    const result = await pool.query(query, values);
    return result.rows[0];
  }

  static async delete(id) {
    const query = 'DELETE FROM articles WHERE id = $1 RETURNING *';
    const result = await pool.query(query, [id]);
    return result.rows[0];
  }
}

module.exports = Article; 