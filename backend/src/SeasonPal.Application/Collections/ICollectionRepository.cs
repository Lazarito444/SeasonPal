using SeasonPal.Domain.Entities;

namespace SeasonPal.Application.Collections;

public interface ICollectionRepository
{
    void Add(Collection collection);
}
