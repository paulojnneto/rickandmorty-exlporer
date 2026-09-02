class ExternalApiError extends Error {
  constructor(resource, status, message) {
    super(message);
    this.name = 'ExternalApiError';
    this.resource = resource;
    this.status = status;
  }
}

function asExternalApiError(resource, error) {
  if (error instanceof ExternalApiError) return error;
  return new ExternalApiError(resource, null, `${resource} request failed`);
}

module.exports = { ExternalApiError, asExternalApiError };
